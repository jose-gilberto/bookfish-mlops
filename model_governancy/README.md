
## Model Governancy

For each trained model registered into our model registry, we can control the permission settings, meaning that we can control who can see which models in the model registry, as well as who can authorize transitions from, e.g., Staging to Production; this is exactly what we want, in that we wish to have a control gate for which models go into production; e.g., maybe the manager of the data scientist who created a given model needs to validate and approve a given model before it transitions into deployment, checking things such as:

    - ensure that the model was tested against a known test set or through cross-validation to confirm that it works
    - ensure that the model was tested against synthetic dataset with a known 'signal'. If it fails this type of test, maybe an error was introduced.