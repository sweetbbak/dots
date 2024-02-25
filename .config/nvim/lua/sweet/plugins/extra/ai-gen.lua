return {
  "David-Kunz/gen.nvim",
  cmd = { "Gen" },
  config = function()
    local gen = require("gen")
    gen.setup({
      model = "zephyr", -- The default model to use.
      display_mode = "split", -- The display mode. Can be "float" or "split".
      show_prompt = false, -- Shows the Prompt submitted to Ollama.
      show_model = false, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      init = function(options)
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      -- Function to initialize Ollama
      command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a lua function returning a command string, with options as the input parameter.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      debug = false,
    })

    gen.prompts["X_Generate_Simple_Description"] = {
      prompt = "Provide a simple and concise description of the following code:\n$register",
      replace = false,
    }

    gen.prompts["X_Generate_Description"] = {
      prompt = "Provide a detailed description of the following code:\n$register",
      replace = false,
    }

    gen.prompts["X_Suggest_Better_Naming"] = {
      prompt = "Take all variable and function names, and provide only a list with suggestions with improved naming:\n$register",
      replace = false,
    }

    gen.prompts["X_Enhance_Grammar_Spelling"] = {
      prompt = "Modify the following text to improve grammar and spelling, just output the final text in English without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Enhance_Wording"] = {
      prompt = "Modify the following text to use better wording, just output the final text without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Make_Concise"] = {
      prompt = "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Review_Code"] = {
      prompt = "Review the following code and make concise suggestions:\n```$filetype\n$register\n```",
    }

    gen.prompts["X_Enhance_Code"] = {
      prompt = "Enhance the following code, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$register\n```",
      replace = false,
      extract = "```$filetype\n(.-)```",
    }

    gen.prompts["X_Simplify_Code"] = {
      prompt = "Simplify the following code, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$register\n```",
      replace = false,
      extract = "```$filetype\n(.-)```",
    }

    gen.prompts["X_Ask"] = { prompt = "Regarding the following text, $input:\n$register" }
    gen.prompts["X_Uwu"] = { prompt = "please reply to the following in an uwu tone of voice, $input:\n$register" }
    gen.prompts["X_Nyaa"] = {
      prompt = "You are Hanakawa Tsubasa from Bakemonogatari, please reply to the folliwing text as an anime cat girl: $input:\n$register",
    }
  end,
}
