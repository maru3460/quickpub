# Tailwind CSS メモ

このプロジェクトでの Tailwind CSS の使用方法と設定について説明するのだ。

## 基本情報

### 使用バージョン

- **Tailwind CSS**: v4.1.4
- **@tailwindcss/vite**: v4.1.4（Vite 統合用）

### 特徴

- Tailwind CSS v4 の最新機能を使用
- shadcn/ui（New York スタイル）と組み合わせ
- カスタムテーマと CSS 変数による高度なデザインシステム
- ダークモード完全対応

## プロジェクト構成

### 設定ファイル

```
frontend/
├── vite.config.ts          # Tailwind統合設定
├── components.json         # shadcn/ui設定
├── app/
│   ├── app.css            # Tailwindメイン設定
│   └── lib/utils.ts       # ユーティリティ関数
```

### Vite 統合（vite.config.ts）

```typescript
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss(), reactRouter(), tsconfigPaths()],
  // ...
});
```

## 使用ライブラリ

### コアライブラリ

- **tailwindcss**: メインの Tailwind CSS
- **@tailwindcss/vite**: Vite 統合プラグイン

### 拡張ライブラリ

- **tailwind-merge**: クラス名の競合解決とマージ
- **tw-animate-css**: アニメーション拡張
- **class-variance-authority (CVA)**: バリアント管理
- **clsx**: 条件付きクラス名生成

### UI 関連

- **shadcn/ui**: UI コンポーネントライブラリ（New York スタイル）
- **lucide-react**: アイコンライブラリ
- **@radix-ui/react-slot**: コンポーネント合成用

## メイン設定（app.css）

### Tailwind CSS v4 の新機能

#### @import 文

```css
@import "tailwindcss";
@import "tw-animate-css";
```

#### カスタムバリアント

```css
@custom-variant dark (&:is(.dark *));
```

#### @theme ディレクティブ

```css
@theme {
  --font-sans: "Inter", ui-sans-serif, system-ui, sans-serif,
    "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
}
```

#### インラインテーマ設定

```css
@theme inline {
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius-xl: calc(var(--radius) + 4px);
  /* カラーシステム */
  --color-background: var(--background);
  --color-foreground: var(--foreground);
  /* ... */
}
```

### カラーシステム

#### ライトモード（:root）

```css
:root {
  --radius: 0.625rem;
  --background: oklch(1 0 0);
  --foreground: oklch(0.145 0 0);
  --primary: oklch(0.205 0 0);
  --secondary: oklch(0.97 0 0);
  /* ... */
}
```

#### ダークモード（.dark）

```css
.dark {
  --background: oklch(0.145 0 0);
  --foreground: oklch(0.985 0 0);
  --primary: oklch(0.922 0 0);
  --secondary: oklch(0.269 0 0);
  /* ... */
}
```

## ユーティリティ関数

### cn()関数（lib/utils.ts）

```typescript
import { type ClassValue, clsx } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

**使用例:**

```typescript
// 条件付きクラス名とマージ
cn("px-4 py-2", isActive && "bg-blue-500", className);
```

## コンポーネント設計パターン

### CVA（Class Variance Authority）を使ったバリアント管理

#### Button コンポーネントの例

```typescript
import { cva, type VariantProps } from "class-variance-authority";

const buttonVariants = cva(
  // ベースクラス
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-all cursor-pointer disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default:
          "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90",
        destructive:
          "bg-destructive text-white shadow-xs hover:bg-destructive/90",
        outline:
          "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-9 px-4 py-2 has-[>svg]:px-3",
        sm: "h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5",
        lg: "h-10 rounded-md px-6 has-[>svg]:px-4",
        icon: "size-9",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
);

function Button({
  className,
  variant,
  size,
  ...props
}: React.ComponentProps<"button"> & VariantProps<typeof buttonVariants>) {
  return (
    <button
      className={cn(buttonVariants({ variant, size, className }))}
      {...props}
    />
  );
}
```

### 使用例

```typescript
// 基本的な使用
<Button>クリック</Button>

// バリアント指定
<Button variant="outline" size="sm">小さなボタン</Button>

// カスタムクラス追加
<Button className="w-full">フル幅ボタン</Button>
```

## shadcn/ui 設定

### components.json

```json
{
  "style": "new-york",
  "rsc": false,
  "tsx": true,
  "tailwind": {
    "config": "",
    "css": "app/app.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "~/components",
    "utils": "~/lib/utils",
    "ui": "~/components/ui"
  },
  "iconLibrary": "lucide"
}
```

## よく使うクラスパターン

### レイアウト

```css
/* フレックスボックス */
flex items-center justify-center
flex-col gap-4

/* グリッド */
grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6

/* 位置指定 */
absolute inset-0
relative z-10
```

### スタイリング

```css
/* 角丸とシャドウ */
rounded-md shadow-xs
rounded-lg shadow-sm

/* ボーダー */
border border-border
border-l-4 border-primary

/* 背景とテキスト */
bg-background text-foreground
bg-primary text-primary-foreground
```

### レスポンシブ

```css
/* ブレークポイント */
sm:text-sm md:text-base lg:text-lg
hidden md:block
w-full md:w-auto
```

### ダークモード

```css
/* 自動切り替え */
bg-white dark:bg-gray-950
text-gray-900 dark:text-gray-100

/* カスタム変数使用 */
bg-background text-foreground
```

## 開発時の注意点

### Tailwind CSS v4 の新機能

1. **@theme ディレクティブ**: CSS 変数を直接定義可能
2. **@custom-variant**: カスタムバリアントの定義
3. **インラインテーマ**: @theme inline での動的設定
4. **設定ファイル不要**: app.css で全て設定可能

### ベストプラクティス

1. **cn()関数を活用**: クラス名の競合を避ける
2. **CVA でバリアント管理**: 一貫性のあるコンポーネント設計
3. **CSS 変数の活用**: テーマの一元管理
4. **レスポンシブファースト**: モバイルから設計

### デバッグ方法

```css
/* 開発時のデバッグ用 */
@apply border border-red-500; /* 要素の境界確認 */
@apply bg-red-100; /* 背景色での確認 */
```

## 参考リンク

- [Tailwind CSS v4 Documentation](https://tailwindcss.com/docs)
- [shadcn/ui Documentation](https://ui.shadcn.com/)
- [Class Variance Authority](https://cva.style/)
- [Tailwind Merge](https://github.com/dcastil/tailwind-merge)
