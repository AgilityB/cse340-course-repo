import db from './db.js';

const getAllCategories = async () => {
    const result = await db.query(`
        SELECT category_id, category_name
        FROM categories
        ORDER BY category_name ASC
    `);
    return result.rows;
};

export { getAllCategories };
