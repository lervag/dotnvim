local snippets = {
  {
    prefix = "new",
    desc = "New entry",
    body = {
      "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
      "  Sto opp         ${1:06:45}",
      "  La meg         x23:30",
      "  Vekt           x89.5 kg",
      "  Vekt (Are)      xx.x kg",
      "  Lengde (Are)    xx.x cm",
      "  Vekt (Sverre)   xx.x kg",
      "  Lengde (Sverre) xx.x cm",
      "  Trening",
      "  Notat           $0",
    },
  },
  {
    prefix = "add",
    desc = "New entry (old type)",
    body = {
      "Sto opp         $1",
      "La meg          $2",
      "Notat           $0",
    },
  },
}

return snippets
