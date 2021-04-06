# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Description
# ==============================================================================
#
#    Tests of reported issues.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Issue #38
# ==============================================================================

@testset "Issue #38 - isoverlong is not defined" begin
    data = ["2.0 ± 1" "3.0 ± 1"]

    expected = """
\\begin{table}
  \\begin{tabular}{rr}
    \\hline\\hline
    \\textbf{Col. 1} & \\textbf{Col. 2} \\\\\\hline
    2.0 ± 1 & 3.0 ± 1 \\\\\\hline\\hline
  \\end{tabular}
\\end{table}
"""

    result = pretty_table(String, data, backend = Val(:latex))
    @test result == expected
end

@testset "Controlling wrap_table" begin
    data = [1 2; 3 4]

    expected = """
\\begin{tabular}{rr}
  \\hline\\hline
  \\textbf{Col. 1} & \\textbf{Col. 2} \\\\\\hline
  1 & 2 \\\\
  3 & 4 \\\\\\hline\\hline
\\end{tabular}
"""

    result = pretty_table(String, data, backend = Val(:latex),
                          wrap_table = false)
    @test result == expected

    expected = """
\\begin{longtable}{rr}
  \\hline\\hline
  \\textbf{Col. 1} & \\textbf{Col. 2} \\\\\\hline
  \\endfirsthead
  \\hline\\hline
  \\textbf{Col. 1} & \\textbf{Col. 2} \\\\\\hline
  \\endhead
  \\hline\\hline
  \\endfoot
  \\endlastfoot
  1 & 2 \\\\
  3 & 4 \\\\\\hline\\hline
\\end{longtable}
"""
    result = pretty_table(String, data, backend = Val(:latex), wrap_table = true,
                          table_type = :longtable)
    @test result == expected
end

# Issue #95
# ==============================================================================

@testset "Issue #95 - Multi-page longtables generate multiple entries in listoftables" begin
    expected = """
\\begin{longtable}{rrrr}
  \\hline\\hline
  \\textbf{1} & \\textbf{2} & \\textbf{3} & \\textbf{4} \\\\
  \\texttt{a} & \\texttt{b} & \\texttt{c} & \\texttt{d} \\\\
  \\texttt{e} & \\texttt{f} & \\texttt{g} & \\texttt{h} \\\\\\hline
  \\endfirsthead
  \\hline\\hline
  \\textbf{1} & \\textbf{2} & \\textbf{3} & \\textbf{4} \\\\
  \\texttt{a} & \\texttt{b} & \\texttt{c} & \\texttt{d} \\\\
  \\texttt{e} & \\texttt{f} & \\texttt{g} & \\texttt{h} \\\\\\hline
  \\endhead
  \\hline\\hline
  \\endfoot
  \\endlastfoot
  1 & false & 1.0 & 1 \\\\
  2 & true & 2.0 & 2 \\\\
  3 & false & 3.0 & 3 \\\\
  4 & true & 4.0 & 4 \\\\
  5 & false & 5.0 & 5 \\\\
  6 & true & 6.0 & 6 \\\\\\hline\\hline
\\end{longtable}
"""

    result = pretty_table(String, data, [1 2 3 4; 'a' 'b' 'c' 'd'; :e :f :g :h];
                          backend = Val(:latex),
                          table_type = :longtable)

    @test result == expected

    expected = """
\\begin{longtable}{rrrr}
  \\caption{Table title}\\\\
  \\hline\\hline
  \\textbf{1} & \\textbf{2} & \\textbf{3} & \\textbf{4} \\\\
  \\texttt{a} & \\texttt{b} & \\texttt{c} & \\texttt{d} \\\\
  \\texttt{e} & \\texttt{f} & \\texttt{g} & \\texttt{h} \\\\\\hline
  \\endfirsthead
  \\hline\\hline
  \\textbf{1} & \\textbf{2} & \\textbf{3} & \\textbf{4} \\\\
  \\texttt{a} & \\texttt{b} & \\texttt{c} & \\texttt{d} \\\\
  \\texttt{e} & \\texttt{f} & \\texttt{g} & \\texttt{h} \\\\\\hline
  \\endhead
  \\hline\\hline
  \\multicolumn{4}{r}{Long table footer}\\\\
  \\hline\\hline
  \\endfoot
  \\endlastfoot
  1 & false & 1.0 & 1 \\\\
  2 & true & 2.0 & 2 \\\\
  3 & false & 3.0 & 3 \\\\
  4 & true & 4.0 & 4 \\\\
  5 & false & 5.0 & 5 \\\\
  6 & true & 6.0 & 6 \\\\\\hline\\hline
\\end{longtable}
"""

    result = pretty_table(String, data, [1 2 3 4; 'a' 'b' 'c' 'd'; :e :f :g :h];
                          backend = Val(:latex),
                          longtable_footer = "Long table footer",
                          table_type = :longtable,
                          title = "Table title")

    @test result == expected
end
