import db from './db.js';

const getAllProjects = async () => {
    const result = await db.query(`
        SELECT p.project_id, p.title, p.description, p.location, p.project_date,
               o.name AS organization_name,
               COALESCE(string_agg(c.category_name, ', ' ORDER BY c.category_name), '') AS categories
        FROM service_projects AS p
        JOIN organization AS o ON o.organization_id = p.organization_id
        LEFT JOIN project_categories AS pc ON pc.project_id = p.project_id
        LEFT JOIN categories AS c ON c.category_id = pc.category_id
        GROUP BY p.project_id, o.name
        ORDER BY p.project_date, p.project_id
    `);
    return result.rows;
};

export { getAllProjects };
