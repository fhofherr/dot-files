local M = {}

function M.config()
    vim.g.projectionist_heuristics = {
        ["go.mod"] = {
            ["*.go"] = {
                alternate = { "{}_test.go", "{}_internal_test.go" },
                type = "source"
            },
            ["*_test.go"] = {
                alternate = "{}.go",
                type = "test"
            },
            ["*_internal_test.go"] = {
                alternate = "{}.go",
                type = "test"
            }
        }
    }
end

return M
