---
id: rai-toolbox
name: Responsible AI Toolbox
category: microsoft
authority: vendor
url: https://responsibleaitoolbox.ai/
covers: [model-assessment, fairness, error-analysis, interpretability, counterfactuals, causal]
agent_use: Cite when evaluating a model or AI feature for fairness, error patterns, interpretability, or counterfactual behavior; when producing measurable evidence for the `ms-rai-standard` Measurement requirement; or when the RAI role generates a Reviewer artifact.
volatility: high
licensing: open (MIT)
last_verified: 2026-05-25
---

# Responsible AI Toolbox

Microsoft's open-source set of tools for assessing AI models and producing evidence for responsible-AI claims. The toolbox consists of the Responsible AI Dashboard, Responsible AI Scorecard, and a set of underlying libraries (Fairlearn, InterpretML, Error Analysis, DiCE counterfactuals, EconML causal). The RAI role uses these to turn principles into numbers.

## Key requirements

- **Toolbox is the default measurement engine for tabular and structured-prediction models** in MS-stack projects. Custom evaluation is justified in `decisions.md`.
- **Responsible AI Dashboard** unifies model performance, error analysis, fairness, interpretability, counterfactuals, and causal analysis in one notebook UI. Outputs are saved to the project's `Libraries/<project>/rai/` evidence folder.
- **Responsible AI Scorecard** generates a PDF / printable report consolidating dashboard findings for stakeholder review. The Scorecard is the artifact cited at the Build and Release gates for RAI evidence.
- **Fairlearn** is the fairness component: disparity metrics (demographic parity, equalized odds, etc.) plus mitigation algorithms. The RAI role names which sensitive features the analysis covers and which disparity metric matches the deployment context.
- **InterpretML** is the interpretability component: glass-box models (EBM) and black-box explainers (SHAP, LIME). The role cites which explainer was used and its limitations.
- **Error Analysis** segments model error along feature axes to surface cohorts with disproportionate failure. Required for any model with consequential decisions.
- **DiCE counterfactuals** produce "what would need to change" examples. Cited when explaining individual model outputs to affected users or reviewers.
- **EconML / causal analysis** estimates treatment effects for policy questions. Used when the deployment question is causal ("would intervening change the outcome?"), not predictive.
- **Toolbox covers tabular and limited NLP/vision; it does not cover generative-AI safety** (use `ai-red-teaming` / PyRIT for that).

## Common misuses

- Running the dashboard once and treating disparity numbers as the answer. Disparity metrics are conditional on the deployment context; the RAI role interprets numbers against the IA.
- Reporting overall accuracy and skipping Error Analysis. Aggregate accuracy hides cohort-level failure modes that drive RAI risk.
- Using the toolbox for a generative system. The toolbox covers prediction/classification; generative-AI evaluation (groundedness, harmful-content, jailbreak resistance) is `ai-red-teaming` and Azure AI Foundry evaluations.

## Notes

- Pairs with `ms-rai-standard` (operationalizes the Measurement requirement), `ai-red-teaming` (covers generative AI where toolbox does not), `azure-ai-foundry` (Foundry's evaluation views overlap and are preferred for hosted Foundry models).
- Volatility is `high`: components evolve and are versioned independently; pin versions in evaluation environments.
