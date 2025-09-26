import org.openurp.parent.Settings.*

ThisBuild / organization := "org.openurp.edu.learning"
ThisBuild / version := "0.0.18-SNAPSHOT"

ThisBuild / scmInfo := Some(
  ScmInfo(
    url("https://github.com/openurp/edu-learning"),
    "scm:git@github.com:openurp/edu-learning.git"
  )
)

ThisBuild / developers := List(
  Developer(
    id = "chaostone",
    name = "Tihua Duan",
    email = "duantihua@gmail.com",
    url = url("http://github.com/duantihua")
  )
)

ThisBuild / description := "OpenURP Edu Learning"
ThisBuild / homepage := Some(url("http://openurp.github.io/edu-learning/index.html"))

val apiVer = "0.47.0"
val starterVer = "0.4.1"
val baseVer = "0.4.56"
val eduCoreVer = "0.3.18"

val openurp_edu_api = "org.openurp.edu" % "openurp-edu-api" % apiVer
val openurp_std_api = "org.openurp.std" % "openurp-std-api" % apiVer
val openurp_stater_web = "org.openurp.starter" % "openurp-starter-web" % starterVer
val openurp_base_tag = "org.openurp.base" % "openurp-base-tag" % baseVer
val openurp_edu_core = "org.openurp.edu" % "openurp-edu-core" % eduCoreVer

lazy val web = (project in file("."))
  .enablePlugins(WarPlugin, TomcatPlugin)
  .settings(
    name := "openurp-edu-learning-webapp",
    common,
    libraryDependencies ++= Seq(openurp_stater_web, openurp_edu_core, openurp_std_api),
    libraryDependencies ++= Seq(openurp_edu_api, openurp_base_tag)
  )
