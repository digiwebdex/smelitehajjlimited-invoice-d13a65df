import { PieChart, Pie, Cell, ResponsiveContainer, Legend, Tooltip } from "recharts";

interface InvoiceStatusPieChartProps {
  paid: number;
  partial: number;
  unpaid: number;
}

const COLORS = {
  paid: "#22c55e",    // Green-500
  partial: "#eab308", // Yellow-500
  unpaid: "#ef4444",  // Red-500
};

export function InvoiceStatusPieChart({ paid, partial, unpaid }: InvoiceStatusPieChartProps) {
  const data = [
    { name: "Paid", value: paid, color: COLORS.paid },
    { name: "Partial", value: partial, color: COLORS.partial },
    { name: "Unpaid", value: unpaid, color: COLORS.unpaid },
  ].filter(item => item.value > 0);

  const total = paid + partial + unpaid;

  if (total === 0) {
    return (
      <div className="h-[280px] flex items-center justify-center text-muted-foreground text-sm">
        No invoice data available
      </div>
    );
  }

  return (
    <div className="h-[280px] w-full">
      <ResponsiveContainer width="100%" height="100%">
        <PieChart>
          <Pie
            data={data}
            cx="50%"
            cy="50%"
            innerRadius={60}
            outerRadius={90}
            paddingAngle={3}
            dataKey="value"
            label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
            labelLine={false}
          >
            {data.map((entry, index) => (
              <Cell key={`cell-${index}`} fill={entry.color} strokeWidth={0} />
            ))}
          </Pie>
          <Tooltip
            contentStyle={{
              backgroundColor: "hsl(var(--card))",
              border: "1px solid hsl(var(--border))",
              borderRadius: "8px",
              boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
            }}
            formatter={(value: number, name: string) => [
              `${value} invoices`,
              name,
            ]}
          />
          <Legend 
            verticalAlign="bottom" 
            height={36}
            formatter={(value) => <span className="text-sm text-foreground">{value}</span>}
          />
        </PieChart>
      </ResponsiveContainer>
    </div>
  );
}
