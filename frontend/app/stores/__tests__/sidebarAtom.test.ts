import { createStore } from "jotai"
import { describe, expect, test } from "vitest"
import { sidebarOpenAtom } from "../sidebarAtom"

describe("sidebarAtom", () => {
  test("初期値はfalseである", () => {
    const store = createStore()
    const initialValue = store.get(sidebarOpenAtom)

    expect(initialValue).toBe(false)
  })

  test("値を変更できる", () => {
    const store = createStore()

    // 初期値を確認
    expect(store.get(sidebarOpenAtom)).toBe(false)

    // 値を変更
    store.set(sidebarOpenAtom, true)
    expect(store.get(sidebarOpenAtom)).toBe(true)

    // 再度変更
    store.set(sidebarOpenAtom, false)
    expect(store.get(sidebarOpenAtom)).toBe(false)
  })

  test("アトムが正しく定義されている", () => {
    // アトムがJotaiのatomであることを確認
    expect(sidebarOpenAtom).toBeDefined()
    expect(typeof sidebarOpenAtom).toBe("object")

    // 初期値の確認
    const store = createStore()
    expect(store.get(sidebarOpenAtom)).toBe(false)
  })
})
