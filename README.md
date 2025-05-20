# 🏎️ F1 Performance Analysis: Driver Pairing & Podium Trends (2000–2024)

A SQL-driven analysis exploring how driver pairing stability impacts Formula 1 constructor performance, using data from 2000 to 2024. Built with BigQuery SQL and designed for future extensibility beyond podium counts.

---

## 📊 Summary of Queries

### 🔍 Query 1 – `f1_base_query.sql`
**Purpose**: Builds a unified dataset of constructor-driver pairings by season and counts how many podiums each team achieved that year.

**What it does**:
- Joins race, result, driver, and constructor tables
- Filters to podium finishes only (positions 1–3)
- Aggregates each constructor’s annual driver lineup
- Counts total podiums per team per year

---

### 🔁 Query 2 – `f102_pairing_stability.sql`
**Purpose**: Identifies constructors who retained the same driver pair across multiple seasons.

**What it does**:
- Groups constructor + driver pair arrays across seasons
- Filters to only those pairings that stayed together for 2+ years
- Tracks all seasons in which the stable pair raced

---

### 📈 Query 3 – `f103_stability_vs_podiums.sql`
**Purpose**: Measures how podium performance varies by driver pairing stability.

**What it does**:
- Joins stable pairings to the base query’s podium data
- Calculates average podiums during stable seasons
- Aggregates and groups by number of years a pair stayed together

---

## 📁 Repository Structure

f1-driver-pairing-analysis/
│
├── README.md
├── queries/
│   ├── 01_base_query.sql
│   ├── 02_pairing_stability.sql
│   └── 03_stability_vs_podiums.sql
├── charts/
│   └── avg_podiums_by_stability.png



---

## 🛠️ Tools Used
- **BigQuery SQL**
- **Google Cloud Console**

---

## 🔑 Key Insight
> Teams with more stable driver pairings (especially those maintained over 3+ seasons) show higher average podium performance, suggesting continuity plays a role in success.

---

## 🔗 Data Source

- [Kaggle: Formula 1 World Championship Dataset (1950–2020)](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020)
