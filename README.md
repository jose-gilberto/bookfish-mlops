
*Machine Learning Operations* (MLOps) refers to an approach where a combination of DevOps and software engineering is leveraged in a manner that enables deploying and maintaining ML models in production reliably and efficiently.

Concepts:

- Development Platform: a collaborative platform for performing ML experiments and empowering the creation of ML models by data scientists should be considered part of the MLOps framework. This platform should enable secure access to data sources. We want the handover from ML training to deployment to be as smooth as possible, wich is more likely the case for such a platform than ML models developed in different local enviroments.

- Model Unit Testing: every time we create, change or retrain a model, we should automatically validate the integrity of the model, e.g.:
    - should meet minimum performance on a test set
    - should perform well on synthetic use case-specific datasets

- Versioning: it should be possible to go back in time to inspect everything relatig to a given model, e.g., what data & code was used. Why? Because if something breaks, we need to be able to go back in time and see why.

- Model Registry: there should be an overview of deployed & decommisioned ML models, their version history, and the deployment stage of each version. Why? If something breaks, we can roll back a  previously archived version back into production.

- Model Governance: only certain people should have access to see training related to any given model. There should be access control for who can request/reject/approve transitions between deployment stages (e.g., dev to test and test to prod) in the model registry.

- Deployments: deployment can be many things, but in this post, i consider the case where we want to deploy a model to cloud infrastructure and expose an API, which enables other peopleto consume and use the model, i.e., i'm not considering cases where we want to deploy ML models into embedded systems. Efficient model deployments on appropriate infrascruture should:
    - support multiple ML frameworks + custom models
    - have well-defined API spec (e.g., Swagger/OpenAPI)
    - suppot containerized model servers

- Monitoring: tracking performance metris (throughput, uptime, etc). Why? If suddenly a model starts returning errors or being unexpectedly slow, we need to know before the end user complains so that we can fix it.

- Feedback: we need to feedback information to the model on how well it is performing. Why? Typically we run predictions on new samples where we do not yet know the ground truth. As we learn the truth, however, we need to inform the model to report on how well is actually doing.

- A/B testing: no matter how solid cross-validation we think we're doing, we never know how the model will perform until it actually gets deployed. It should be easy to perform A/B experiments with live models within the MLOps framework.

- Drift detection: typically, the longer time a given model is deployed, the worse it becomes as circumstances changes compared to when the model was trained. We can try to monitor and alert on these different circumstances, or "drifts" before they get too severe:
    - Concept of drift: when the relation between input and output has changed
    - Prediction drift: changes in predictions, but the model still holds
    - Label drift: change in the model's outcomes compared to training data
    - Feature drift: change in the distribution of model input data.

- Outlier detection: if a deployed model receives an input sample that is significantly different from anything observed during training, we can try to identify this sample as a potential outlier, and the returned prediction should be masked as such, indicating that the end user should be careful in trusting the prediction.

- Adversarial Attack Detection: we should be warned when adversarial samples attack our models (e.g., someone trying to abuse/manipulate the outcome of our algorithms).

- Interpretability: the ML deployments should support endpoints returning the explanation of our predictions, e.g., through SHAP values. Why? for a lot of use cases, a prediction is not enough, and the end user needs to know why a given prediction was made.

- Governance of deployments: we not only need access restrictions on who can see the data, trained models, etc., but also who can eventually use the deployed models. These deployed models can often be just as confidential as the data they were trained on.

- Data centricity: rather than focus on model performance & improvements, it makes sense than an MLOps frameworks also enables an increased focus on how the end user can improve data quality and breadth.




