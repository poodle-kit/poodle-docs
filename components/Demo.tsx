export function Demo({ children }: { children: React.ReactNode }) {
  return (
    <div className="my-6 p-6 border border-gray-200 dark:border-gray-800 rounded-lg bg-gray-50 dark:bg-gray-900">
      {children}
    </div>
  )
}
