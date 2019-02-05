Vagrant configurations tio have an Elastic-Stack (ELKS)
======================================================

.. image:: https://travis-ci.com/dlux/vagrant-elasticstack.svg?branch=master
    :alt: Build Status @ Travis
    :target: https://travis-ci.com/dlux/vagrant-elasticstack

Overview
--------

Elastic-Stack refers mainly to Elasticsearch + Kibana + [Beats | Logstash]

Elasticsearch is a popular open source search server that is used for real-time distributed search and analysis of data.

Kibana is the tooling to create nice visualizations of the data.

Beats(lightweight) and Logstash are the ingest mechanism to collect data. It means agents sitting on the OS of the systems being monitored from where data will be collected.

.. image:: images/elks.png
  :align: center

What is this Project?
---------------------

Current project is a vagrant-virtualbox environment created to explore and learn more about the so-called elastic-stack.

Initial Model:

- 1 all-in-one (aio) vm with elasticsearch and Kibana installed.
- 1 vm with Beats installed sending information to elasticsearch (testing the E2E)

Future Models:
- Multinode - create multiple vms to create an elasticsearch cluster instead of an aio
- Containers - create multiple containers (on top of a single vm) to create a cluster for elasticsearch instead of an aio
- Kubernetes - having a kubernetes installation (on top of a sigle or multiple vms) use elasticsearch charms to deploy an elasticsearch cluster 

Run
---

.. code-block:: bash

  $ git clone https://github.com/dlux/vagrant-elasticstack.git

Further information: http://www.luzcazares.com/utilities/elkstack

