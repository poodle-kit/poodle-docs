import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
  // Next.js Core Web Vitals rules
  ...nextVitals,
  // Next.js TypeScript rules
  ...nextTs,
  // Override default ignores of eslint-config-next.
  globalIgnores([
    ".next/**",
    "out/**",
    "build/**",
    "next-env.d.ts",
    "node_modules/**",
    ".turbo/**",
    "dist/**",
    "coverage/**",
  ]),
  // Custom rules
  {
    rules: {
      // 미사용 변수 경고 설정, 접두사로 _ 사용 시 무시
      "@typescript-eslint/no-unused-vars": [
        "warn",
        {
          argsIgnorePattern: "^_",
          varsIgnorePattern: "^_",
        },
      ],
      // any 타입 사용 경고
      "@typescript-eslint/no-explicit-any": "warn",

      // TS, React 17+ 관련
      "react/react-in-jsx-scope": "off",
      "react/prop-types": "off",
      // TSX 내 특수문자 사용 경고 해제
      "react/no-unescaped-entities": "off",
      // 재할당 가능한 변수는 let 대신 const 사용
      "prefer-const": "error",
      "no-var": "error",
    },
  },
]);

export default eslintConfig;
