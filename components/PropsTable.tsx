interface PropData {
  prop: string
  type: string
  default: string
  description: string
}

export function PropsTable({ data }: { data: PropData[] }) {
  return (
    <div className="my-6 overflow-x-auto">
      <table className="w-full border-collapse">
        <thead>
          <tr className="border-b-2 border-gray-200 dark:border-gray-800">
            <th className="text-left p-3 font-semibold">Prop</th>
            <th className="text-left p-3 font-semibold">Type</th>
            <th className="text-left p-3 font-semibold">Default</th>
            <th className="text-left p-3 font-semibold">Description</th>
          </tr>
        </thead>
        <tbody>
          {data.map((row, i) => (
            <tr
              key={i}
              className="border-b border-gray-100 dark:border-gray-900 hover:bg-gray-50 dark:hover:bg-gray-900"
            >
              <td className="p-3 font-mono text-sm text-blue-600 dark:text-blue-400">
                {row.prop}
              </td>
              <td className="p-3 font-mono text-sm text-purple-600 dark:text-purple-400">
                {row.type}
              </td>
              <td className="p-3 font-mono text-sm text-gray-600 dark:text-gray-400">
                {row.default}
              </td>
              <td className="p-3 text-sm text-gray-700 dark:text-gray-300">
                {row.description}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
