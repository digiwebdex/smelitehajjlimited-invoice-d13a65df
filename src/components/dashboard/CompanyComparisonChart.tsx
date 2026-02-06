import { Bar, BarChart, ResponsiveContainer, XAxis, YAxis, Tooltip, Legend, Cell } from "recharts";

interface CompanyComparisonChartProps {
  data: { name: string; paid: number; due: number }[];
}

export function CompanyComparisonChart({ data }: CompanyComparisonChartProps) {
  const formatCurrency = (value: number) => {
    if (value >= 1000000) {
      return `৳${(value / 1000000).toFixed(1)}M`;
    }
    if (value >= 1000) {
      return `৳${(value / 1000).toFixed(0)}k`;
    }
    return `৳${value}`;
  };

  // Truncate long names
  const truncateName = (name: string, maxLength: number = 10) => {
    return name.length > maxLength ? name.substring(0, maxLength) + "..." : name;
  };

  if (data.length === 0) {
    return (
      <div className="h-[280px] flex items-center justify-center text-muted-foreground text-sm">
        No company data available
      </div>
    );
  }

  return (
    <div className="h-[280px] w-full">
      <ResponsiveContainer width="100%" height="100%">
        <BarChart 
          data={data} 
          margin={{ top: 10, right: 10, left: 0, bottom: 0 }}
        >
          <XAxis
            dataKey="name"
            stroke="hsl(var(--muted-foreground))"
            fontSize={10}
            tickLine={false}
            axisLine={false}
            tickFormatter={(value) => truncateName(value)}
            interval={0}
            angle={-15}
            textAnchor="end"
            height={50}
          />
          <YAxis
            stroke="hsl(var(--muted-foreground))"
            fontSize={11}
            tickLine={false}
            axisLine={false}
            tickFormatter={formatCurrency}
          />
          <Tooltip
            cursor={{ fill: "hsl(var(--muted))", opacity: 0.3 }}
            contentStyle={{
              backgroundColor: "hsl(var(--card))",
              border: "1px solid hsl(var(--border))",
              borderRadius: "8px",
              boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
            }}
            labelStyle={{ color: "hsl(var(--foreground))", fontWeight: 600 }}
            formatter={(value: number, name: string) => [
              `৳${new Intl.NumberFormat("en-BD").format(value)}`,
              name === "paid" ? "Collected" : "Due",
            ]}
          />
          <Legend 
            verticalAlign="top"
            height={36}
            formatter={(value) => (
              <span className="text-sm text-foreground">
                {value === "paid" ? "Collected" : "Due"}
              </span>
            )}
          />
          <Bar 
            dataKey="paid" 
            fill="#22c55e" 
            radius={[4, 4, 0, 0]} 
            maxBarSize={35}
          />
          <Bar 
            dataKey="due" 
            fill="#ef4444" 
            radius={[4, 4, 0, 0]} 
            maxBarSize={35}
          />
        </BarChart>
      </ResponsiveContainer>
    </div>
  );
}
