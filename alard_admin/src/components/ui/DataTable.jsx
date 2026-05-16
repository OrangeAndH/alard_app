'use client';

import { Edit2, Trash2 } from 'lucide-react';

export default function DataTable({ columns, data, onEdit, onDelete, idKey = 'id' }) {
  return (
    <div className="card glass-panel" style={{ overflowX: 'auto', padding: '1rem 0' }}>
      <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
        <thead>
          <tr style={{ borderBottom: '2px solid var(--color-olive-light)' }}>
            {columns.map((col, idx) => (
              <th key={idx} style={{ padding: '1rem 1.5rem', color: 'var(--color-olive)', fontWeight: '700', fontSize: '0.95rem' }}>
                {col.header}
              </th>
            ))}
            {(onEdit || onDelete) && (
              <th style={{ padding: '1rem 1.5rem', color: 'var(--color-olive)', fontWeight: '700', fontSize: '0.95rem', textAlign: 'right' }}>
                Actions
              </th>
            )}
          </tr>
        </thead>
        <tbody>
          {data.length === 0 ? (
            <tr>
              <td colSpan={columns.length + 1} style={{ padding: '2rem', textAlign: 'center', color: 'var(--color-text-muted)' }}>
                No records found.
              </td>
            </tr>
          ) : (
            data.map((row, rIdx) => (
              <tr key={row[idKey] || rIdx} style={{ 
                borderBottom: '1px solid rgba(0,0,0,0.05)',
                backgroundColor: rIdx % 2 === 0 ? 'transparent' : 'rgba(0,0,0,0.01)'
              }}>
                {columns.map((col, cIdx) => (
                  <td key={cIdx} style={{ padding: '1rem 1.5rem', color: 'var(--color-text-main)', fontSize: '0.95rem' }}>
                    {col.render ? col.render(row) : row[col.accessor]}
                  </td>
                ))}
                {(onEdit || onDelete) && (
                  <td style={{ padding: '1rem 1.5rem', textAlign: 'right' }}>
                    <div style={{ display: 'flex', gap: '0.5rem', justifyContent: 'flex-end' }}>
                      {onEdit && (
                        <button onClick={() => onEdit(row)} style={styles.iconBtn} title="Edit">
                          <Edit2 size={18} color="var(--color-olive)" />
                        </button>
                      )}
                      {onDelete && (
                        <button onClick={() => onDelete(row)} style={styles.iconBtn} title="Delete">
                          <Trash2 size={18} color="#dc2626" />
                        </button>
                      )}
                    </div>
                  </td>
                )}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}

const styles = {
  iconBtn: {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    padding: '0.4rem',
    borderRadius: '4px',
    transition: 'background-color 0.2s',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
  }
};
