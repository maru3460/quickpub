# データモデル設計

## モデル定義

### User

| カラム名        | 型       | 制約                | 説明                       |
| --------------- | -------- | ------------------- | -------------------------- |
| id              | integer  | PK                  | ID                         |
| email           | string   | UNIQUE, NOT NULL    | メールアドレス             |
| password_digest | string   | NOT NULL            | パスワード                 |
| status          | integer  | NOTNULL, default: 0 | 権限(0: general, 1: admin) |
| created_at      | datetime |                     | 作成日時                   |
| updated_at      | datetime |                     |                            |

### Site

| カラム名    | 型      | 制約 | 説明         |
| ----------- | ------- | ---- | ------------ |
| id          | integer | PK   | ID           |
| user_id     | integer | FK   | ユーザー ID  |
| name        | string  |      | サイト名     |
| description | string  |      | サイトの説明 |
| subdomain   | string  |      | サブドメイン |

### Content

| カラム名 | 型      | 制約 | 説明           |
| -------- | ------- | ---- | -------------- |
| id       | integer | PK   | ID             |
| site_id  | integer | FK   | サイト ID      |
| path     | string  |      | ファイル名     |
| content  | text    |      | ファイルの中身 |

## ER 図

```mermaid
erDiagram
    User ||--o{ Site : has_many
    Site ||--o{ Content : has_many

    User {
        int id PK
        string email UK
        string password_digest
        int status
        datetime created_at
        datetime updated_at
    }

    Site {
        int id PK
        int user_id FK
        string name
        string description
        string subdomain UK
        datetime created_at
        datetime updated_at
    }

    Content {
        int id PK
        int site_id FK
        string path
        text content
        datetime created_at
        datetime updated_at
    }
```
