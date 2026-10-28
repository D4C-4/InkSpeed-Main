import js from "@eslint/js";
import eslintPluginPrettier from "eslint-plugin-prettier/recommended";
import globals from "globals";
import reactHooks from "eslint-plugin-react-hooks";
import reactRefresh from "eslint-plugin-react-refresh";
import tseslint from "typescript-eslint";

export default tseslint.config(
  { ignores: ["dist", ".output", ".vinxi"] },
  {
    extends: [js.configs.recommended, ...tseslint.configs.recommended],
    files: ["**/*.{ts,tsx}"],
    languageOptions: {
      ecmaVersion: 2020,
      globals: globals.browser,
    },
    plugins: {
      "react-hooks": reactHooks,
      "react-refresh": reactRefresh,
    },
    rules: {
      ...reactHooks.configs.recommended.rules,
      "no-restricted-imports": [
        "error",
        {
          paths: [
            {
              name: "server-only",
              message:
                "TanStack Start does not use the Next.js `server-only` package. Rename the module to `*.server.ts` or mark it with `@tanstack/react-start/server-only`.",
            },
          ],
        },
      ],
      "react-refresh/only-export-components": ["warn", { allowConstantExport: true }],
      "@typescript-eslint/no-unused-vars": "off",
      "no-restricted-globals": [
        "error",
        {
          name: "confirm",
          message:
            "Use ConfirmDialog instead. Native dialogs can leave Electron unable to focus text inputs after they close.",
        },
        {
          name: "alert",
          message:
            "Do not use native alerts. Render the message in the page instead; native dialogs break Electron input focus.",
        },
        {
          name: "prompt",
          message:
            "Do not use native prompts. Use an in-page form instead; native dialogs break Electron input focus.",
        },
      ],
      "no-restricted-properties": [
        "error",
        {
          object: "window",
          property: "confirm",
          message:
            "Use ConfirmDialog instead. Native dialogs can leave Electron unable to focus text inputs after they close.",
        },
        {
          object: "window",
          property: "alert",
          message:
            "Do not use native alerts. Render the message in the page instead; native dialogs break Electron input focus.",
        },
        {
          object: "window",
          property: "prompt",
          message:
            "Do not use native prompts. Use an in-page form instead; native dialogs break Electron input focus.",
        },
      ],
    },
  },
  eslintPluginPrettier,
);
