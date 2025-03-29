module.exports = {
  env: {
    es6: true,
    node: true,
  },
  parserOptions: {
    ecmaVersion: 2018,
  },
  extends: ["eslint:recommended"],
  rules: {
    "no-restricted-globals": ["error", "name", "length"],
    "prefer-arrow-callback": "error",
    quotes: ["error", "double", { allowTemplateLiterals: true }],
    "object-curly-spacing": ["error", "always"],
    "object-curly-newline": [
      "error",
      {
        multiline: true,
        consistent: true,
      },
    ],
    indent: ["error", 2],
    "max-len": ["error", { code: 100 }],
    "comma-dangle": ["error", "always-multiline"],
    "no-multiple-empty-lines": ["error", { max: 1 }],
  },
  overrides: [
    {
      files: ["**/*.spec.*"],
      env: {
        mocha: true,
      },
      rules: {},
    },
  ],
  globals: {},
};
