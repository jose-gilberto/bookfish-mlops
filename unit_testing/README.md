
## Model Unit Testing

Databricks enables us to define jobs, which lets us run a given notebook with a set of input parameters. We can use this to bundle up our training code so that when we wish to re-train our model, we simply need to re-run our job, which could be done with a simple REST request, instead of manually going into the training notebook and re-training the model. A crucial part of this kind of "operationalization" of our model training is that we include checks within the notebook to ensure that the model is still working as expected on, e.g., test datasets or synthetic datasets. An example could be to add the following:

```python
test_loss, test_acc = evaluate(X, y)
if test_acc < 0.95:
    raise Exception('Model performance did not meet minimum requirements')
```

Have added these checks, or 'tests', in the script, we can create a job in Databricks, pointing for this script/notebook. To re-train our model, we simply tell the job to create a 'run' with the script/notebook.

