This directory contains Terraform files for provisioning the lab environment. **Note that these files are for reference, and meant to be deployed in the order specified in the Boundary Cloud Host Catalogs tutorial.** The plan will not deploy correctly without exporting the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_REGION` environment variables defined in the tutorial.

**Please note that usage of this template will incur costs associated with your AWS account.** You are responsible for these costs. See the Dynamic Host Catalogs tutorial section **Cleanup and teardown** to learn about destroying these resources after completing the tutorial.

The Terraform plan creates:

- 4 Amazon Linux instances
  - AMI ID `ami-083602cee93914c0c`
  - Size: `t3.micro`

The VMs are named and tagged as follows:

- boundary-1-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-2-dev
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-3-production
    - Tags: `service-type`: `database` and `application`: `production`
- boundary-4-production
    - Tags: `service-type`: `database` and `application`: `prod`

The fourth VM, `boundary-vm-4`, is purposefully misconfigured with a tag of `application`: `prod` that is corrected by the learner in the Dynamic Host Catalogs tutorial.