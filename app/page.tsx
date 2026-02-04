import Link from "next/link";

export default function HomePage() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="container mx-auto px-6 py-32 text-center">
        <h1 className="text-6xl font-bold mb-6 bg-linear-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
          Welcome to Poodle
        </h1>
        <p className="text-xl text-gray-600 dark:text-gray-400 mb-12 max-w-2xl mx-auto">
          A modern, fast, and beautiful React component library with
          comprehensive documentation
        </p>

        <div className="flex gap-4 justify-center flex-wrap">
          <Link
            href="/docs/getting-started"
            className="bg-blue-600 hover:bg-blue-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors inline-block"
          >
            Get Started →
          </Link>
          <Link
            href="/docs"
            className="border border-gray-300 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-800 px-8 py-3 rounded-lg font-semibold transition-colors inline-block"
          >
            View Docs
          </Link>
        </div>
      </section>

      {/* Features */}
      <section className="container mx-auto px-6 py-20">
        <h2 className="text-3xl font-bold text-center mb-12">Features</h2>
        <div className="grid md:grid-cols-3 gap-8">
          <FeatureCard
            icon="⚡"
            title="Lightning Fast"
            description="Built with Next.js 16 and Turbopack for blazing fast performance"
          />
          <FeatureCard
            icon="🎨"
            title="Beautiful Design"
            description="Tailwind CSS 4 integration with customizable themes"
          />
          <FeatureCard
            icon="📚"
            title="Well Documented"
            description="Comprehensive documentation with live examples"
          />
          <FeatureCard
            icon="♿"
            title="Accessible"
            description="Built with accessibility in mind, WCAG compliant"
          />
          <FeatureCard
            icon="🎯"
            title="TypeScript"
            description="Full TypeScript support for type-safe development"
          />
          <FeatureCard
            icon="📦"
            title="Tree-shakeable"
            description="Import only what you need for optimal bundle size"
          />
        </div>
      </section>

      {/* Quick Example */}
      <section className="bg-gray-50 dark:bg-gray-900 py-20">
        <div className="container mx-auto px-6">
          <h2 className="text-3xl font-bold text-center mb-12">
            Quick Example
          </h2>
          <div className="max-w-3xl mx-auto">
            <pre className="bg-gray-900 text-gray-100 p-6 rounded-lg overflow-x-auto">
              <code>{`import { Button, Card, Input } from 'poodle'

function App() {
  return (
    <Card>
      <h2>Welcome!</h2>
      <Input placeholder="Enter your name" />
      <Button variant="primary">Submit</Button>
    </Card>
  )
}`}</code>
            </pre>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="container mx-auto px-6 py-20 text-center">
        <h2 className="text-3xl font-bold mb-6">Ready to get started?</h2>
        <p className="text-xl text-gray-600 dark:text-gray-400 mb-8">
          Install Poodle and start building beautiful UIs today
        </p>
        <div className="bg-gray-900 text-gray-100 p-4 rounded-lg max-w-md mx-auto mb-8">
          <code>npm install poodle</code>
        </div>
        <Link
          href="/docs/getting-started/installation"
          className="text-blue-600 dark:text-blue-400 hover:underline font-semibold"
        >
          Read installation guide →
        </Link>
      </section>
    </div>
  );
}

function FeatureCard({
  icon,
  title,
  description,
}: {
  icon: string;
  title: string;
  description: string;
}) {
  return (
    <div className="p-6 border border-gray-200 dark:border-gray-800 rounded-lg hover:shadow-lg transition-shadow">
      <div className="text-4xl mb-4">{icon}</div>
      <h3 className="text-xl font-semibold mb-2">{title}</h3>
      <p className="text-gray-600 dark:text-gray-400">{description}</p>
    </div>
  );
}
