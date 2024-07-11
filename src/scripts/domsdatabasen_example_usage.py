"""Example usage of the Domsdatabasen API"""

from alexandra_ai_data.domsdatabasen import Domsdatabasen

domsdatabasen = Domsdatabasen()

case = domsdatabasen.get_case(case_id="100")

print(case)
