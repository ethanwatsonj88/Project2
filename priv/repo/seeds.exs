# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Project2.Repo.insert!(%Project2.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Project2.Repo
alias Project2.Users.User

#Repo.insert!(%User{email: "ethan@gmail.com", username: "ethanwatsonj88", admin: true})
#Repo.insert!(%User{email: "justin@gmail.com", username: "xiaju", admin: true})
#Repo.insert!(%User{email: "nat@gmail.com", username: "nattheteacher", admin: false})

#alias Project2.Songs.Song
#Repo.insert!(%Song{name: "sorry by justin beeber", user_id: 1, link: ""})

#alias Project2.Follows.Follow
#Repo.insert!(%Follow{follower_id: 1, following_id: 2})
#Repo.insert!(%Follow{follower_id: 3, following_id: 2}) 
