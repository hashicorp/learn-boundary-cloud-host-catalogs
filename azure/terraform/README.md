This directory contains Terraform files for provisioning the lab environment. **Note that these files are for reference, and meant to be deployed in the order specified in the Boundary Cloud Host Catalogs tutorial.** The plan will not deploy correctly without exporting the `ARM_CLIENT_ID` and `ARM_CLIENT_SECRET` environment variables defined in the tutorial.

**Please note that usage of this template will incur costs associated with your Azure subscription.** You are responsible for these costs. See the Dynamic Host Catalogs tutorial section **Cleanup and teardown** to learn about destroying these resources after completing the tutorial.

The Terraform plan creates:

- 4 Centos VMs
  - Publisher: OpenLogin
  - SKU: 7_9-gen2
  - Size: Standard_B1ls

The VMs are named and tagged as follows:

- boundary-vm-1
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-vm-2
    - Tags: `service-type`: `database` and `application`: `dev`
- boundary-vm-3
    - Tags: `service-type`: `database` and `application`: `production`
- boundary-vm-4
    - Tags: `service-type`: `database` and `application`: `prod`

The fourth VM, `boundary-vm-4`, is purposefully misconfigured with a tag of `application`: `prod` that is corrected by the learner in the Dynamic Host Catalogs tutorial.