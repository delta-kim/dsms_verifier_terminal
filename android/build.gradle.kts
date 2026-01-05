
// android/build.gradle.kts
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.6.0") // Android Gradle 插件
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // Kotlin 插件
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    
    // Ensure all subprojects use the same NDK version
    project.afterEvaluate {
        if (project.plugins.hasPlugin("com.android.application") || 
            project.plugins.hasPlugin("com.android.library")) {
            val android = project.extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            android?.ndkVersion = "27.0.12077973"
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
