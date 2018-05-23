# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# NEED this seed,  do not delete
Loan.create(id: 1, loan_token: "not_loaned", :requestee_name => "", :requestee_email => "")

# NEED this seed, do not delete
ResearchProject.create(id: 1, researcher_name: "", researcher_email: "")

# Fill thhe inventory with some duff values
Inventory.create([
  {id: 1, item_name: '13" Laptop Test', item_category: 'Laptops', total_stock: 4, total_available: 4, loan_time: 'Medium'},
  {id: 2, item_name: '15" Laptop Test', item_category: 'Laptops', total_stock: 2, total_available: 2, loan_time: 'Medium'},
  {id: 3, item_name: 'Apple Tablet', item_category: 'Tablets', total_stock: 4, total_available:4, loan_time: 'Medium'}])

Item.create([
  {model_type: 'Dell Inspiron 5370', serial_equipment_number: 'S253AA2', purchase_price: 449.0, purchase_date: Date.parse('2016-08-20'), is_research_project: false, inventory_id: 1, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'Dell XPS', serial_equipment_number: 'S6531PK9', purchase_price: 1200.0, purchase_date: Date.parse('2017-05-05'), is_research_project: false, inventory_id: 1, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'Dell Inspiron 5370', serial_equipment_number: 'S753HS3', purchase_price: 449.0, purchase_date: Date.parse('2016-08-20'), is_research_project: false, inventory_id: 1, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'Dell XPS', serial_equipment_number: 'S453LH3', purchase_price: 1200.0, purchase_date: Date.parse('2017-05-05'), is_research_project: false, inventory_id: 1, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'Macbook Pro', serial_equipment_number: 'WE093JK473HGB', purchase_price: 1569.50, purchase_date: Date.parse('2016-02-20'), is_research_project: false, inventory_id: 2, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'Macbook Pro', serial_equipment_number: 'WF045JL423PGB', purchase_price: 1569.50, purchase_date: Date.parse('2016-02-20'), is_research_project: false, inventory_id: 2, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'iPad 2', serial_equipment_number: 'FE166GG123DDB', purchase_price: 900.0, purchase_date: Date.parse('2015-03-22'), is_research_project: false, inventory_id: 3, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'iPad 2', serial_equipment_number: 'FF126FG233RWV', purchase_price: 900.0, purchase_date: Date.parse('2015-03-22'), is_research_project: false, inventory_id: 3, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'iPad Pro', serial_equipment_number: 'QD987DS113PDB', purchase_price: 1200.0, purchase_date: Date.parse('2017-01-20'), is_research_project: false, inventory_id: 3, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1},
  {model_type: 'iPad Pro', serial_equipment_number: 'QE327AC145PPP', purchase_price: 1200.0, purchase_date: Date.parse('2017-01-20'), is_research_project: false, inventory_id: 3, disposed_of: false, loan_token: 'not_loaned', in_use: false, research_project_id: 1}])
