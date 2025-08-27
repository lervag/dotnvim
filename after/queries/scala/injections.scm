;; extends

(interpolated_string_expression
  (identifier) @type
  (#any-of? @type "SQL" "sql")
  (interpolated_string) @injection.content
  (#offset! @injection.content 0 3 0 -3)
  (#set! injection.language "sql")
)

(
  (call_expression
     function: (field_expression
                 field: (identifier) @methodName
                 (#eq? @methodName "execute"))
     arguments: (arguments
                  (string) @injection.content))

  (#set! injection.language "sql")
  (#offset! @injection.content 0 1 0 -1))

(
  (call_expression
     function: (field_expression
                 field: (identifier) @methodName
                 (#eq? @methodName "execute"))
     arguments: (arguments
                  (interpolated_string_expression
                    (interpolated_string) @injection.content)))

  (#set! injection.language "sql")
  (#offset! @injection.content 0 3 0 -3))
