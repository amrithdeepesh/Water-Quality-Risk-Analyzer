# PIN lookup data

The browser uses the compact local file `india-pincode-offices.json`. It was generated from the Department of Posts CSV published on India's Open Government Data Platform:

- Source file: https://data.gov.in/sites/default/files/all_india_PO_list_without_APS_offices_ver2_lat_long.csv
- Catalog: https://data.gov.in/resources/all-india-pincode-directory-contact-details-along-latitude-and-longitude
- Publisher: Ministry of Communications, Department of Posts
- Retrieved: 12 October 2026; the source file's data vintage is not clearly stated
- Fields retained: PIN, post office, district, state, latitude, longitude
- Coverage in this extract: 142 post-office coordinates across 111 distinct PIN codes from 154,797 source rows

The dataset does not cover most PIN codes. If a PIN has no mapped coordinate, the app explains that and lets the user capture or enter the test point directly. Do not treat the post-office coordinate as the water sample location. A PIN identifies a broader postal area; a post-office point only helps navigate.

The exact sample point comes from device GPS or the user's map click and remains subject to device/map accuracy. The source is distributed under the Government Open Data License - India. Recheck the source catalog and its current terms and refresh the dataset before relying on it operationally.
