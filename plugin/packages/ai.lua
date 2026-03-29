require("lervag.util").load_delayed(function()
  vim.pack.add { "https://github.com/Robitx/gp.nvim" }

  require("gp").setup {
    toggle_target = "tabnew",
    providers = {
      openai = { disable = true },
      mistral = {
        endpoint = "https://api.mistral.ai/v1/chat/completions",
        secret = os.getenv "MISTRAL_API_KEY",
      },
    },
    agents = {
      {
        name = "Mistral",
        provider = "mistral",
        chat = true,
        command = true,
        model = { model = "mistral-large-2512" },
        max_tokens = 4096,
        system_prompt = "You are a general AI assistant.\n\n"
          .. "The user provided the additional info about how they would like you to respond:\n\n"
          .. "- Be brief and consise!\n"
          .. "- If you're unsure don't guess and say you don't know instead.\n"
          .. "- Ask question if you need clarification to provide better answer.\n"
          .. "- Think deeply and carefully from first principles step by step.\n"
          .. "- Zoom out first to see the big picture and then zoom in to details.\n"
          .. "- Use Socratic method to improve your thinking and coding skills.\n"
          .. "- Don't elide any code from your output if the answer requires coding.\n"
          .. "- Take a deep breath; You've got this!\n",
      },
    },
  }

  local dispatcher = require "gp.dispatcher"
  local original_prepare_payload = dispatcher.prepare_payload
  dispatcher.prepare_payload = function(messages, model, provider)
    local output = original_prepare_payload(messages, model, provider)
    if provider == "mistral" then
      output.max_completion_tokens = nil
    end
    return output
  end

  vim.keymap.set("n", "<f1>", "<cmd>GpChatToggle<cr>", { desc = "GpChat" })
end)
