;; extends

(interpolated_string_expression
  (identifier) @type
    (#any-of? @type "SQL" "sql")
  (interpolated_string) @injection.content
    (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "sql"))
