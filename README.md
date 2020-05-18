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
  - name: Shared Info
    id: project-base
    uses: aplaceformom/terraform-project-base-action@master
    with:
      workspace: dev
      project: es-example-action
      owner: techops
      email: alex.moreno@aplaceformom.com
      remote_state_bucket: apfm-terraform-remotestate
      remote_lock_table: terraform-statelock
      shared_state_key: terraform/apfm.tfstate
        debug: false
  - name: Elasticsearch Deploy
    uses: aplaceformom/terraform-elasticsearch-action@master
    with:
      es_domain: demo-elasticsearch-actions # <--- Domain Name 
      es_source_ip: 10.0.0.0/8,170.150.57.105/32 # <--- IP Allowed to connect
      es_source_resource: null 
      es_instance_type: 'm3.xlarge.elasticsearch'
      es_instance_count: 2
      es_vpc: true
      aws_assume_role: arn:aws:iam::${{ steps.project-base.outputs.account_id }}:role/TerraformApply
      aws_external_id: ${{ steps.project-base.outputs.external_id }}
      destroy: false
```

**es_instance_type:** (Valid options)

```
[i3.2xlarge.elasticsearch, m5.4xlarge.elasticsearch, i3.4xlarge.elasticsearch, m3.large.elasticsearch, r4.16xlarge.elasticsearch, t2.micro.elasticsearch, m4.large.elasticsearch, d2.2xlarge.elasticsearch, m5.large.elasticsearch, i3.8xlarge.elasticsearch, i3.large.elasticsearch, d2.4xlarge.elasticsearch, t2.small.elasticsearch, c4.2xlarge.elasticsearch, c5.2xlarge.elasticsearch, c4.4xlarge.elasticsearch, d2.8xlarge.elasticsearch, c5.4xlarge.elasticsearch, m3.medium.elasticsearch, c4.8xlarge.elasticsearch, c4.large.elasticsearch, c5.xlarge.elasticsearch, c5.large.elasticsearch, c4.xlarge.elasticsearch, c5.9xlarge.elasticsearch, d2.xlarge.elasticsearch, t2.medium.elasticsearch, c5.18xlarge.elasticsearch, i3.xlarge.elasticsearch, i2.xlarge.elasticsearch, r3.2xlarge.elasticsearch, r4.2xlarge.elasticsearch, m5.xlarge.elasticsearch, m4.10xlarge.elasticsearch, r3.4xlarge.elasticsearch, r5.2xlarge.elasticsearch, m5.12xlarge.elasticsearch, m4.xlarge.elasticsearch, r4.4xlarge.elasticsearch, m5.24xlarge.elasticsearch, m3.xlarge.elasticsearch, i3.16xlarge.elasticsearch, r5.4xlarge.elasticsearch, ultrawarm1.large.elasticsearch, m3.2xlarge.elasticsearch, r3.8xlarge.elasticsearch, r3.large.elasticsearch, r5.xlarge.elasticsearch, m4.2xlarge.elasticsearch, r4.8xlarge.elasticsearch, r4.xlarge.elasticsearch, r4.large.elasticsearch, r5.12xlarge.elasticsearch, m5.2xlarge.elasticsearch, i2.2xlarge.elasticsearch, r3.xlarge.elasticsearch, r5.24xlarge.elasticsearch, r5.large.elasticsearch, m4.4xlarge.elasticsearch]
```

**es_volume_type:** 

- standard
- gp2
- io1

**tags**

- More information about the valid options to be used, can be found [here](https://aplaceformom.atlassian.net/wiki/spaces/TECHOPS/pages/1049133728/2020+AWS+Tagging+Standards) 

## Know issues:

- Multiples AZ are not available for a lack of the provider, https://github.com/terraform-providers/terraform-provider-aws/issues/4038#issuecomment-472304026.

## Test executed:

- Add more nodes to a cluster previously created: 
  - Result: Nodes were added without interrupt service.
- Remove nodes from the cluster previosly created:
  - Result: Nodes were removed without interruption.
- Upsize nodes:
  - Result: Nodes were resized without interrupt service.
- Downsize nodes:
  - Result: Nodes were downsized without interruption.


## URL used to create this action

- https://www.terraform.io/docs/providers/aws/r/elasticsearch_domain.html
- https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html
- https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/aes-supported-instance-types.html
- https://docs.aws.amazon.com/cli/latest/reference/es/create-elasticsearch-domain.html