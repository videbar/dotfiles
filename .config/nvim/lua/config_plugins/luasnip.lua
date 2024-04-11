local ls = require("luasnip")
-- local types = require("luasnip.util.types")

ls.config.set_config({
    updateevents = "TextChanged,TextChangedI",
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

ls.add_snippets("lua", { ls.parser.parse_snippet("fn", "function($1)\n    $0\nend") })
ls.add_snippets("cpp", {
    ls.parser.parse_snippet("cout", "std::cout << $0 << std::endl;"),
    ls.parser.parse_snippet("cerr", "std::cerr << $0 << std::endl;"),
    ls.parser.parse_snippet("if", "if ($1) {\n    $0\n}"),
    ls.parser.parse_snippet("elif", "else if ($1) {\n    $0\n}"),
    ls.parser.parse_snippet("else", "else {\n    $0\n}"),
    ls.parser.parse_snippet("for", "for (auto $1; $1 <= $2; $1++) {\n    $0\n}"),
    ls.parser.parse_snippet(
        "main",
        "int main(int argc, char *argv[]) {\n    $0\n    return 0;\n}"
    ),
})
ls.add_snippets("python", {
    ls.parser.parse_snippet("pf", 'print(f"{$0 = }")'),
    ls.parser.parse_snippet("try", "try:\n    $1\nexcept $2:\n    $0"),
    ls.parser.parse_snippet("for", "for $1 in $2:\n    $0"),
})
ls.add_snippets("markdown", { ls.parser.parse_snippet("cb", "```$1\n$0\n```") })
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
