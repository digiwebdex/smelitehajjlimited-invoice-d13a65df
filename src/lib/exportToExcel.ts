import * as XLSX from 'xlsx';
import { Invoice } from '@/types';

interface ExportInvoice {
  invoiceNumber: string;
  clientName: string;
  companyName: string;
  date: string;
  dueDate: string;
  status: string;
  totalAmount: number;
  paidAmount: number;
  dueAmount: number;
  items: string;
}

export const exportInvoicesToExcel = (
  invoices: Invoice[],
  getCompanyName: (companyId: string) => string,
  filename: string = 'invoices'
) => {
  const data: ExportInvoice[] = invoices.map((invoice) => ({
    invoiceNumber: invoice.invoiceNumber,
    clientName: invoice.clientName,
    companyName: getCompanyName(invoice.companyId),
    date: new Date(invoice.date).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    }),
    dueDate: invoice.dueDate
      ? new Date(invoice.dueDate).toLocaleDateString('en-US', {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
        })
      : '—',
    status: invoice.status.charAt(0).toUpperCase() + invoice.status.slice(1),
    totalAmount: invoice.totalAmount,
    paidAmount: invoice.paidAmount,
    dueAmount: invoice.dueAmount,
    items: invoice.items.map((item) => `${item.title}: ৳${item.amount}`).join('; '),
  }));

  const worksheet = XLSX.utils.json_to_sheet(data, {
    header: [
      'invoiceNumber',
      'clientName',
      'companyName',
      'date',
      'dueDate',
      'status',
      'totalAmount',
      'paidAmount',
      'dueAmount',
      'items',
    ],
  });

  // Set column headers
  worksheet['A1'] = { v: 'Invoice #', t: 's' };
  worksheet['B1'] = { v: 'Client Name', t: 's' };
  worksheet['C1'] = { v: 'Company', t: 's' };
  worksheet['D1'] = { v: 'Date', t: 's' };
  worksheet['E1'] = { v: 'Due Date', t: 's' };
  worksheet['F1'] = { v: 'Status', t: 's' };
  worksheet['G1'] = { v: 'Total Amount (৳)', t: 's' };
  worksheet['H1'] = { v: 'Paid Amount (৳)', t: 's' };
  worksheet['I1'] = { v: 'Due Amount (৳)', t: 's' };
  worksheet['J1'] = { v: 'Items', t: 's' };

  // Set column widths
  worksheet['!cols'] = [
    { wch: 15 }, // Invoice #
    { wch: 20 }, // Client Name
    { wch: 20 }, // Company
    { wch: 12 }, // Date
    { wch: 12 }, // Due Date
    { wch: 10 }, // Status
    { wch: 15 }, // Total Amount
    { wch: 15 }, // Paid Amount
    { wch: 15 }, // Due Amount
    { wch: 40 }, // Items
  ];

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet, 'Invoices');

  // Generate and download the file
  XLSX.writeFile(workbook, `${filename}.xlsx`);
};
