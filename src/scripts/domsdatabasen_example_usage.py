from alexandra_ai_data.domsdatabasen import DomsDatabasen

domsdatabasen = DomsDatabasen()

case = domsdatabasen.get_case(case_id="100")

print(case)
