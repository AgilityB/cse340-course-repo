-- ========================================
-- Organization Table
-- ========================================
CREATE TABLE organization (
    organization_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    contact_email VARCHAR(255) NOT NULL,
    logo_filename VARCHAR(255) NOT NULL
);



-- ========================================
-- Insert sample data: Organizations
-- ========================================
INSERT INTO organization (name, description, contact_email, logo_filename)
VALUES
('BrightFuture Builders', 'A nonprofit focused on improving community infrastructure through sustainable construction projects.', 'info@brightfuturebuilders.org', 'brightfuture-logo.png'),
('GreenHarvest Growers', 'An urban farming collective promoting food sustainability and education in local neighborhoods.', 'contact@greenharvest.org', 'greenharvest-logo.png'),
('UnityServe Volunteers', 'A volunteer coordination group supporting local charities and service initiatives.', 'hello@unityserve.org', 'unityserve-logo.png');


-- ==========================================
-- SERVICE PROJECTS TABLE
-- ==========================================

CREATE TABLE service_projects (
project_id SERIAL PRIMARY KEY,
organization_id INTEGER NOT NULL
    REFERENCES organization(organization_id)
    ON DELETE CASCADE,

title VARCHAR(150) NOT NULL,
description TEXT NOT NULL,
location VARCHAR(100) NOT NULL,
project_date DATE NOT NULL
);






-- ==========================================
-- SAMPLE SERVICE PROJECTS
-- ==========================================
-- Organization IDs are looked up by name so this works with fresh SERIAL IDs.
INSERT INTO service_projects (organization_id, title, description, location, project_date)
SELECT organization_id, 'Neighborhood Park Cleanup',
       'Remove litter and improve shared green spaces.',
       'Community Park', DATE '2027-02-20'
FROM organization WHERE name = 'UnityServe Volunteers';

INSERT INTO service_projects (organization_id, title, description, location, project_date)
SELECT organization_id, 'Community Garden Workshop',
       'Teach neighbors how to grow vegetables sustainably.',
       'GreenHarvest Community Garden', DATE '2027-03-06'
FROM organization WHERE name = 'GreenHarvest Growers';

INSERT INTO service_projects (organization_id, title, description, location, project_date)
SELECT organization_id, 'School Library Improvement',
       'Repair and organize reading spaces for local students.',
       'Community Primary School', DATE '2027-03-13'
FROM organization WHERE name = 'BrightFuture Builders';

INSERT INTO service_projects (organization_id, title, description, location, project_date)
SELECT organization_id, 'Community Health Awareness Day',
       'Coordinate volunteer-led health education, wellness resources, and community outreach.',
       'Umuahia, Abia State', DATE '2027-03-20'
FROM organization WHERE name = 'UnityServe Volunteers';

INSERT INTO service_projects (organization_id, title, description, location, project_date)
SELECT organization_id, 'Youth Digital Skills Workshop',
       'Help young people develop basic computer, internet safety, and digital literacy skills.',
       'Aba, Abia State', DATE '2027-04-10'
FROM organization WHERE name = 'BrightFuture Builders';

-- ==========================================
-- CATEGORIES: MANY-TO-MANY RELATIONSHIP
-- ==========================================
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE project_categories (
    project_id INTEGER NOT NULL REFERENCES service_projects(project_id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(category_id) ON DELETE CASCADE,
    PRIMARY KEY (project_id, category_id)
);

INSERT INTO categories (category_name) VALUES
    ('Environmental'),
    ('Educational'),
    ('Community Service'),
    ('Health and Wellness');

-- Assign meaningful categories using project titles and category names.
INSERT INTO project_categories (project_id, category_id)
SELECT p.project_id, c.category_id
FROM service_projects AS p
JOIN categories AS c ON
    (p.title = 'Neighborhood Park Cleanup' AND c.category_name IN ('Environmental', 'Community Service'))
    OR (p.title = 'Community Garden Workshop' AND c.category_name IN ('Environmental', 'Educational'))
    OR (p.title = 'School Library Improvement' AND c.category_name IN ('Educational', 'Community Service'))
    OR (p.title = 'Community Health Awareness Day' AND c.category_name IN ('Health and Wellness', 'Community Service'))
    OR (p.title = 'Youth Digital Skills Workshop' AND c.category_name IN ('Educational', 'Community Service'));

-- Ensure any other existing projects also receive at least one category.
INSERT INTO project_categories (project_id, category_id)
SELECT p.project_id, c.category_id
FROM service_projects AS p
CROSS JOIN categories AS c
WHERE c.category_name = 'Community Service'
  AND NOT EXISTS (
      SELECT 1 FROM project_categories AS pc WHERE pc.project_id = p.project_id
  );

-- ==========================================
-- VERIFICATION QUERIES (run manually after setup)
-- ==========================================
-- SELECT * FROM categories ORDER BY category_name;
-- SELECT p.title, c.category_name FROM service_projects p
-- JOIN project_categories pc ON pc.project_id = p.project_id
-- JOIN categories c ON c.category_id = pc.category_id
-- ORDER BY p.title, c.category_name;
-- SELECT p.project_id, p.title FROM service_projects p
-- LEFT JOIN project_categories pc ON pc.project_id = p.project_id
-- WHERE pc.project_id IS NULL; -- should return no rows
