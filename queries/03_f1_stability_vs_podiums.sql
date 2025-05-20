SELECT
  stable_years,
  AVG(avg_podiums) AS overall_avg_podiums
FROM `f1_data.pairing_podiums`
GROUP BY stable_years
ORDER BY stable_years;
