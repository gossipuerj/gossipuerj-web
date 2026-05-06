# Pendencias

- Likes em posts: o backend ainda nao retorna `likedByCurrentUser` nem um campo equivalente. Com isso, o frontend consegue saber apenas `likesCount`, mas nao consegue saber se o usuario atualmente logado ja curtiu um determinado post. Por enquanto, o estado de like no frontend e apenas otimista/local durante a sessao atual da tela.
