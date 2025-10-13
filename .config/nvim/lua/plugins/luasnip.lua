return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    config = function(_, opts)
        local ls = require("luasnip")

        ls.config.set_config({
            keep_roots = true,
            link_roots = true,
            link_children = true,
            updateevents = { "TextChanged", "TextChangedI" },
        })

        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        local snippets_common_c_cpp = {
            ls.parser.parse_snippet("inc", "#include <$0>\n"),
            ls.parser.parse_snippet("inl", '#include "$0"\n'),
            ls.parser.parse_snippet("def", "#define $1 $0\n"),
            ls.parser.parse_snippet("idf", "#ifdef $1\n    $2\n#endif"),
            ls.parser.parse_snippet("indf", "#ifndef $1\n    $2\n#endif"),
            ls.parser.parse_snippet("if", "if ($1) {\n    $2\n} $0"),
            ls.parser.parse_snippet("elif", "else if ($1) {\n    $2\n} $0"),
            ls.parser.parse_snippet("else", "else {\n    $0\n}"),
            ls.parser.parse_snippet(
                "swi",
                "switch ($1) {\n"
                    .. "    case $2:\n"
                    .. "        $3\n"
                    .. "        break;\n"
                    .. "    $0}"
            ),
            ls.parser.parse_snippet("case", "case $1:\n    $2\n    break;\n$0"),
            ls.parser.parse_snippet("while", "while ($1) {\n    $0\n}"),
            ls.parser.parse_snippet(
                "main",
                "int main(int argc, char *argv[]) {\n    $0\n    return 0;\n}"
            ),
        }
        local snippets_cpp = {
            ls.parser.parse_snippet("cout", "std::cout << $0 << std::endl;"),
            ls.parser.parse_snippet("cerr", "std::cerr << $0 << std::endl;"),
            ls.parser.parse_snippet(
                "for",
                "for (auto $1 = $2; $1 < $3; $1++) {\n    $0\n}"
            ),
        }
        local snippets_c = {
            ls.parser.parse_snippet("for", "for ($1; $2; $3) {\n    $0\n}"),
            ls.parser.parse_snippet("tp", "typedef struct {\n    $1\n} $0;"),
            ls.parser.parse_snippet("tn", "typedef enum {\n    $1\n} $0;"),
        }

        ls.add_snippets("cpp", snippets_cpp)
        ls.add_snippets("cpp", snippets_common_c_cpp)
        ls.add_snippets("c", snippets_c)
        ls.add_snippets("c", snippets_common_c_cpp)

        ls.add_snippets("lua", {
            ls.parser.parse_snippet("af", "function($1)\n    $0\nend"),
            ls.parser.parse_snippet("lf", "local function $1($2)\n    $0\nend"),
            ls.parser.parse_snippet("fip", "for _, $1 in ipairs($2) do\n    $0\nend"),
            ls.parser.parse_snippet("fp", "for $1, $2 in pairs($3) do\n    $0\nend"),
            ls.parser.parse_snippet("if", "if $1 then\n    $0\nend"),
            ls.parser.parse_snippet("elif", "elseif $1 then\n    $2\n$0"),
            ls.parser.parse_snippet("else", "else\n    $1\n$0"),
        })

        ls.add_snippets("python", {
            ls.parser.parse_snippet("pf", 'print(f"{$0 = }")'),
            ls.parser.parse_snippet("try", "try:\n    $1\nexcept $2:\n    $0"),
            ls.parser.parse_snippet("for", "for $1 in $2:\n    $0"),
        })

        ls.add_snippets("markdown", {
            ls.parser.parse_snippet("cb", "```$1\n$0\n```"),
            ls.parser.parse_snippet("cl", "- [ ] $0"),
        })

        ls.add_snippets("tex", {
            ls.parser.parse_snippet("bg", "\\begin{$1}\n    $0\n\\end{$1} "),
            ls.parser.parse_snippet(
                "eq",
                "\\begin{equation}\n    $1\n    \\label{eq:$0}\n\\end{equation} "
            ),
            ls.parser.parse_snippet(
                "fig",
                "\\begin{figure}[$1]\n"
                    .. "    \\centering\n"
                    .. "    \\includegraphics[$2]{$3}\n"
                    .. "    \\caption{$4}\n"
                    .. "    \\label{fig:$0}\n"
                    .. "\\end{figure}"
            ),
            ls.parser.parse_snippet(
                "vec",
                "\\begin{figure}[$1]\n"
                    .. "    \\centering\n"
                    .. "    \\input{$2}\n"
                    .. "    \\caption{$3}\n"
                    .. "    \\label{fig:$0}\n"
                    .. "\\end{figure}"
            ),
        })
        ls.add_snippets("matlab", {
            ls.parser.parse_snippet("for", "for $1=1:$2\n    $0\nend"),
        })
        ls.add_snippets("zig", {
            ls.parser.parse_snippet("main", "pub fn main() !void {\n    $0\n}"),
            ls.parser.parse_snippet("std", 'const std = @import("std");'),
        })
    end,
}
