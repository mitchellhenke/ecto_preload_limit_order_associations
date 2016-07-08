# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
#

post_1 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 1"})
post_2 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 2"})
post_3 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 3"})
post_4 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 4"})
post_5 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 5"})
post_6 = PreloadLimitOrderAssociation.Repo.insert!(%PreloadLimitOrderAssociation.Post{body: "post 6"})

posts = [post_1, post_2, post_3, post_4, post_5, post_6]

Enum.each(posts, fn(post) ->
  Enum.each(1..10, fn(n) ->
    params = %{
      body: "comment #{n}",
      post_id: post.id
    }
    PreloadLimitOrderAssociation.Comment.changeset(%PreloadLimitOrderAssociation.Comment{}, params)
    |> PreloadLimitOrderAssociation.Repo.insert!
  end)
end)

