# IBM AML | Money Laundering Detection

## Project Overview

This project investigates suspicious financial transactions
using data analytics, feature engineering and machine learning.

The goal is to identify potentially suspicious transactions
while improving the efficiency of bank investigation teams.

**Dataset:** IBM AML synthetic transaction data

**Total transactions:** 31,898,238

**Technologies:** Python, SQL, Google BigQuery, dbt,
scikit-learn, BigQuery ML

## Project Workflow

1. Data preparation and quality checks
2. SQL transformations with dbt
3. Statistical hypothesis analysis (H1-H6)
4. Feature engineering
5. Time-based train, validation and test splits
6. Class imbalance analysis
7. Machine learning model development
8. Model evaluation and comparison
9. Alarm prioritization and operational analysis
10. Feature importance and SHAP explanations

## Data Split

| Dataset | Period | Transactions |
|---|---|---:|
| TRAIN | 2022-09-01 to 2022-09-10 | 20,319,000 |
| VALIDATION | 2022-09-11 to 2022-09-13 | 4,689,009 |
| TEST | 2022-09-14 to 2022-09-16 | 6,883,242 |
| OOD_TEST | 2022-09-17 to 2022-09-28 | 6,987 |

## Machine Learning Models

Four classification algorithms were investigated:

- Logistic Regression
- Decision Tree
- Random Forest
- Gradient Boosting

The final selected candidate is **Gradient Boosting V2**,
using 13 transaction and historical behavioral features.

### Feature Engineering

The V2 model includes six behavioral features:

- Sender's prior transaction count
- Sender's transaction count during the previous 24 hours
- Sender's transaction count during the previous 7 days
- Sender's historical average transaction amount
- Hours since the sender's previous transaction
- Current amount relative to historical average

Historical windows exclude transactions occurring at
the same timestamp and later transactions.

## Final TEST Results

| Metric | Gradient Boosting V1 | Gradient Boosting V2 |
|---|---:|---:|
| Average Precision | 0.028345 | 0.323305 |
| True positives in top 5,000 | 320 | 2,088 |
| Precision@5,000 | 6.40% | 41.76% |
| Recall@5,000 | 4.62% | 30.12% |

At an investigation budget of 5,000 alerts, V2 detected
1,768 more positive transactions than V1.

### V2 VALIDATION Metrics

| Metric | Value |
|---|---:|
| Precision at threshold 0.5 | 0.009145 |
| Recall at threshold 0.5 | 0.982243 |
| F1-score at threshold 0.5 | 0.018121 |
| ROC-AUC | 0.977928 |
| Average Precision | 0.343141 |
| Trapezoidal PR-AUC | 0.357029 |

### Confusion Matrix at Threshold 0.5

| Actual / Predicted | Normal | Suspicious |
|---|---:|---:|
| Normal | 3,999,346 | 683,243 |
| Suspicious | 114 | 6,306 |

A fixed threshold of 0.5 generates many false alerts.
Risk-based ranking is therefore evaluated under
fixed investigation budgets.

## Feature Importance

Top Gradient Boosting V2 features by importance gain:

1. Payment format
2. Previous 24-hour transaction count
3. Previous 7-day transaction count
4. Hours since last transaction
5. Cross-currency transaction indicator

Local transaction explanations were also generated
using BigQuery ML's SHAP-based explainability.

## Operational Findings

- Behavioral features substantially improved risk ranking.
- The highest-ranked alerts are dominated by ACH transactions.
- Non-ACH suspicious transactions remain difficult to prioritize.
- Alternative alert quotas were evaluated on validation data.
- A 50-alert non-ACH quota improved segment coverage,
  but the observed overall gain was very small.

## Out-of-Distribution Evaluation

The OOD_TEST period contains 6,987 transactions,
including 4,084 labeled positives (58.45%).

The measured Average Precision was 0.951879.

Because the positive class prevalence is dramatically
different from the regular TEST period, this result
must not be interpreted as equivalent production performance.

## Data Leakage and Limitations

Checks confirmed:

- Expected 13 model inputs
- No target label or direct target-copy feature
- Correct chronological dataset boundaries
- Consistency of historical transaction windows
- Sampled independent verification of prior counts

These checks do not prove the complete absence of leakage.

Additional limitations:

- The dataset is synthetic.
- Model performance differs across payment types.
- Behavioral features may depend on highly active accounts.
- Production-time feature availability requires verification.
- External validation and ongoing monitoring are necessary.

## Repository Notes

- `models/` contains dbt SQL transformations.
- `tests/` contains dbt data quality tests.
- The local Decision Tree binary is excluded from Git.
- BigQuery ML model objects are not stored in this repository.
- Reproducing training requires the underlying datasets,
  appropriate BigQuery access and model training configuration.

## Conclusion

Gradient Boosting V2 substantially improved suspicious
transaction prioritization on the held-out TEST period.

The project demonstrates how transaction history,
SQL-based data modeling and explainable machine learning
can support AML investigation workflows.

This is an analytical proof of concept, not a
production-ready AML decision system.