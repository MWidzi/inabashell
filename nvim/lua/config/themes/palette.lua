return {
    'roobert/palette.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require('palette').setup {
            palettes = {
                main = 'custom_main',
                accent = 'custom_accent',
                state = 'custom_state',
            },
            custom_palettes = {
                main = {
                    custom_main = {
                        color0 = '#343434', -- bg
                        color1 = '#404040',
                        color2 = '#454545',
                        color3 = '#858585',
                        color4 = '#b2b2b2',
                        color5 = '#c7c7c7',
                        color6 = '#e1e1e1',
                        color7 = '#f3f3f3',
                        color8 = '#ffffff',
                    },
                },
                accent = {
                    custom_accent = {
                        accent0 = '#000000', -- main1
                        accent1 = '#E95274', -- main2
                        accent2 = '#E84F56',
                        accent3 = '#C4C9FC',
                        accent4 = '#8FB6E8',
                        accent5 = '#F4D177',
                        accent6 = '#F6DE29',
                    },
                },
                state = {
                    custom_state = {
                        error = '#000000',
                        warning = '#F5959F',
                        hint = '#F4D177',
                        ok = '#8FB6E8',
                        info = '#C4C9FC',
                    },
                },
            },
            italics = true,
            transparent_background = false,
        }

        vim.cmd 'colorscheme palette'
    end,
}
