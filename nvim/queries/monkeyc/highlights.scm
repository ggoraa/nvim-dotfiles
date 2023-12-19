(null_literal) @variable.builtin
(string_literal) @string
(number_literal) @number
(bool_literal) @boolean
(comment) @comment

[ ";" "," ] @punctuation.delimiter
[ "(" ")" "[" "]" "{" "}"] @punctuation.bracket

[
 "+"
 "-"
 "*"
 "/"
 "%"
 "<<"
 ">>"
 "<"
 "<="
 ">"
 ">="
 "=="
 "!="
 "="
] @operator

[
 "var"
 "const"
 "if"
 "else"
 "as"
 (visibility_modifier)
] @keyword

[
 "using"
 "import"
] @include

"function" @keyword.function

(function_declaration name: (simple_identifier) @function)
(call_expression (identifier path: (simple_identifier) @type target: (simple_identifier) @function.call))
