# CHORDS Portal

A testbed for CHORDS developer and user experiences. It will allow us
to explore technical and usabilty aspects of CHORDS. It can be used
to demonstrate CHORDS design and operational concepts.

For a slick presentation, see the [CHORDS user documentation pages](http://chordsrt.com).
The [CHORDS wiki](https://github.com/NCAR/chords/wiki) has lots of nitty-gritty information.

The goal is to demonstrate that:
* The development and deployment workflow can be rational and organized,
  allowing multiple developers to contribute to a simple, robust and maintainable system.
* The user experience allows novices to deploy a new CHORDS Portal instance with a minimum
  web infrastructure knowledge. This instance allows them to immediately receive,
  archive and serve real-time data from simple instruments.

This project will provide experience in:
* DevOps (in general) for the CHORDS developers.
* Design, provisioning and deployment of the CHORDS "appliance".
* User interface requirements and usability.

The CHORDS Portal web application will provide limited but immediately useful
functionality:
* A home page, with a logo and some areas for project definition
  and customization.
* A query that can receive a tupple of data, and ingest it into the database.
* A query that can return data from the database.
* A webpage that can navigate and show data in a tabular form, and perhaps 
  deliver a CSV file.
* A webpage that provides a URL builder, than can be used immediately, and used
  as a template for client applications.
* A webpage which provides a summary of the current data holdings and 
  ingest activity.

