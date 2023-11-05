;; extends

(interpolated_string_expression
  (identifier) @type
    (#eq? @type "SQL")
  (interpolated_string) @injection.content
    (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "sql"))
