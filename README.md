AWS Terraform Elasticsearch service action
============================
This repository is home to an _Elasticsearch_ GitHub action used as a template for
rapid development of Terraform based actions. The goal of this model is to
provide a common framework for deploying modularized infrastructure with
configuration paramters supplied as part of the GitHub workflow.

Usage
-----
Simply clone this repository and start developing your Terraform IAC. The
entrypoint handler for this action will automatically translate GitHub inputs
into terraform variables.

For example, if your define the following `action.yaml`:
```yaml
  - name: Elasticsearch Deploy
    uses: aplaceformom/terraform-elasticsearch-action@master
    with:
      workspace: dev
      project: examples
      owner: MyTeam
      email: myteam@mydomain.org
```

Then you are able to use these inputs directly as Terraform varables:
```
resource "a_terraform_resource" "example" {
  paramter1 = var.foo
  paramter2 = var.bar
}
```

## URL used to create this action

- https://www.terraform.io/docs/providers/aws/r/elasticsearch_domain.html
- https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html
- https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html