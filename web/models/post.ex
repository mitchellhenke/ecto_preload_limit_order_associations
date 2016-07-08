defmodule PreloadLimitOrderAssociation.Post do
  use PreloadLimitOrderAssociation.Web, :model

  schema "posts" do
    field :body, :string
    has_many :comments, PreloadLimitOrderAssociation.Comment
    field :some_comments, {:map, :array}, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body])
    |> validate_required([:body])
  end

  def load_some_comments(posts, comment_count) do
    parameters = Enum.reduce(posts, [], fn(post, parameters) ->
      parameters ++ [post.id, comment_count]
    end)

    [_first_post | without_first_post] = posts
    last_parameter_index = 2
    initial_sql = "SELECT id, body, post_id, updated_at, inserted_at from (SELECT id, body, post_id, updated_at, inserted_at FROM comments WHERE (comments.post_id = $1) ORDER BY inserted_at DESC LIMIT $2) as t1"

    {sql, _} = Enum.reduce(without_first_post, {initial_sql, last_parameter_index}, fn(_post, {sql, last_parameter_index}) ->
      more_sql = " UNION ALL SELECT id, body, post_id, updated_at, inserted_at from (SELECT id, body, post_id, updated_at, inserted_at FROM comments WHERE (comments.post_id = $#{last_parameter_index + 1}) ORDER BY inserted_at DESC LIMIT $#{last_parameter_index + 2}) as t1"
      last_parameter_index = last_parameter_index + 2
      sql = sql <> more_sql

      {sql, last_parameter_index}
    end)

    %{rows: rows} = Ecto.Adapters.SQL.query!(PreloadLimitOrderAssociation.Repo, sql, parameters)
    comments = Enum.map(rows, fn([id, body, post_id, updated_at, inserted_at]) ->
      %PreloadLimitOrderAssociation.Comment{id: id, body: body, post_id: post_id, updated_at: updated_at, inserted_at: inserted_at}
    end)

    Enum.map(posts, fn(post) ->
      %{post | some_comments: Enum.filter(comments, fn(comment) -> comment.post_id == post.id end)}
    end)
  end
end
