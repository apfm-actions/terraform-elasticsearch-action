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

**es_instance_type:** (Valid options)

```
[i3.2xlarge.elasticsearch, ultrawarm1.xlarge.elasticsearch, m5.4xlarge.elasticsearch, t3.xlarge.elasticsearch, i3.4xlarge.elasticsearch, m3.large.elasticsearch, r4.16xlarge.elasticsearch, t2.micro.elasticsearch, m4.large.elasticsearch, d2.2xlarge.elasticsearch, t3.micro.elasticsearch, m5.large.elasticsearch, i3.8xlarge.elasticsearch, i3.large.elasticsearch, d2.4xlarge.elasticsearch, t2.small.elasticsearch, c4.2xlarge.elasticsearch, t3.small.elasticsearch, c5.2xlarge.elasticsearch, c4.4xlarge.elasticsearch, d2.8xlarge.elasticsearch, c5.4xlarge.elasticsearch, m3.medium.elasticsearch, c4.8xlarge.elasticsearch, c4.large.elasticsearch, c5.xlarge.elasticsearch, c5.large.elasticsearch, c4.xlarge.elasticsearch, c5.9xlarge.elasticsearch, d2.xlarge.elasticsearch, ultrawarm1.medium.elasticsearch, t3.nano.elasticsearch, t3.medium.elasticsearch, t2.medium.elasticsearch, t3.2xlarge.elasticsearch, c5.18xlarge.elasticsearch, i3.xlarge.elasticsearch, i2.xlarge.elasticsearch, r3.2xlarge.elasticsearch, r4.2xlarge.elasticsearch, m5.xlarge.elasticsearch, m4.10xlarge.elasticsearch, r3.4xlarge.elasticsearch, r5.2xlarge.elasticsearch, m5.12xlarge.elasticsearch, m4.xlarge.elasticsearch, r4.4xlarge.elasticsearch, m5.24xlarge.elasticsearch, m3.xlarge.elasticsearch, i3.16xlarge.elasticsearch, t3.large.elasticsearch, r5.4xlarge.elasticsearch, ultrawarm1.large.elasticsearch, m3.2xlarge.elasticsearch, r3.8xlarge.elasticsearch, r3.large.elasticsearch, r5.xlarge.elasticsearch, m4.2xlarge.elasticsearch, r4.8xlarge.elasticsearch, r4.xlarge.elasticsearch, r4.large.elasticsearch, r5.12xlarge.elasticsearch, m5.2xlarge.elasticsearch, i2.2xlarge.elasticsearch, r3.xlarge.elasticsearch, r5.24xlarge.elasticsearch, r5.large.elasticsearch, m4.4xlarge.elasticsearch]
```

**es_volume_type:** 

- standard
- gp2
- io1

## URL used to create this action

- https://www.terraform.io/docs/providers/aws/r/elasticsearch_domain.html
- https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html
- https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html
- https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html