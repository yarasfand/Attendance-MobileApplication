# 🚀 Flutter Live Location Tracking Mega Attendance App 

<h3><strong>⌛ Real-time location tracking for automated attendance marking. 🌟</strong></h3>

<p>
✨ Crafted from scratch with meticulous coding, this mega project boasts a fully responsive interface. Embracing the MVC folder architecture and utilizing SQLite for local data storage, it ensures a structured and scalable codebase. Leveraging the power of the Bloc pattern, the app seamlessly integrates live location tracking for automated attendance marking. Additionally, efficient API consumption enhances connectivity and data flow. Elevate your attendance tracking experience with this cutting-edge Flutter application! 📊💻
  
</p>

# 📁 Folder Architecture

<ul>
  <li><strong>Models:</strong>
    <ul>
      <li>Separation of Concerns: Models encapsulate data structures and business logic, promoting a clear separation of concerns.</li>
      <li>Data Integrity: Responsible for handling data-related tasks, ensuring integrity and consistency.</li>
    </ul>
  </li>

  <li><strong>Views:</strong>
    <ul>
      <li>User Interface (UI): Views focus on the presentation layer, representing the UI components and layouts.</li>
      <li>Responsive Design: Follows a responsive design approach for optimal user experience on various devices.</li>
    </ul>
  </li>

  <li><strong>Controllers:</strong>
    <ul>
      <li>Logic Handling: Controllers manage the flow of data between models and views, handling the application's business logic.</li>
      <li>Event Handling: Responds to user inputs, orchestrating the interaction between the UI and underlying data models.</li>
    </ul>
  </li>

  <li><strong>Folder Structure:</strong>
    <ul>
      <li><code>lib</code> Directory Organization: The <code>lib</code> directory is organized into subdirectories representing the MVC components.</li>
      <li>Modularity: Each module (Model, View, Controller) resides in its respective directory, promoting modularity and maintainability.</li>
    </ul>
  </li>

  <li><strong>Clear Code Organization:</strong>
    <ul>
      <li>Readability: MVC architecture enhances code readability by separating different aspects of the application.</li>
      <li>Ease of Collaboration: Facilitates collaboration among developers as they can work on specific components without interfering with others.</li>
    </ul>
  </li>

  <li><strong>Scalability:</strong>
    <ul>
      <li>Supports Growth: The MVC structure supports scalability, allowing for easy integration of new features or modifications.</li>
      <li>Future-Proof: The organized codebase is adaptable to changing project requirements over time.</li>
    </ul>
  </li> 
</ul>

#  🚪🚪 TWO PORTALS

### -> 👨‍💼 ADMIN SIDE


<ul>
  <li><strong>Attendance Management:</strong>
    <ul>
      <li>Admin controls the attendance of employees.</li>
      <li>Admin's own attendance is also maintained.</li>
    </ul>
  </li>

  <li><strong>Location-Based Attendance:</strong>
    <ul>
      <li>Admin sets the location on the map.</li>
      <li>Employee attendance is marked based on specific coordinates.</li>
      <li>Presence within a specified radius results in attendance marking <code>(geofencing)</code>; otherwise, it's not recorded.</li>
      <li>Admin sets the radius (e.g., 1km) for geofencing.</li>
    </ul>
  </li>

  <li><strong>Leave Approval:</strong>
    <ul>
      <li>Admin can approve or disapprove leave requests from employees.</li>
    </ul>
  </li>

  <li><strong>Manual Attendance Marking:</strong>
    <ul>
      <li>Admin has the ability to manually mark the attendance of employees.</li>
    </ul>
  </li>

  <li><strong>Specific Coordinates for Employees:</strong>
    <ul>
      <li>Admin can set specific coordinates and radius for different employees.</li>
      <li>Example: Separate coordinates and radius for office-based employees and on-site employees.</li>
    </ul>
  </li>

  <li><strong>Access to Reports:</strong>
    <ul>
      <li>Admin can access daily and monthly reports of employee attendance.</li>
    </ul>
  </li>

  <li><strong>Time and Attendance Policies:</strong>
    <ul>
      <li>Admin can define and enforce time and attendance policies.</li>
      <li>Example: Working hours, overtime rules, etc.</li>
    </ul>
  </li>
</ul>


### -> 👨‍💼 EMPLOYEE SIDE

<ul>
  <li><strong>Attendance Marking:</strong>
    <ul>
      <li>Employees mark attendance by clicking their photo.</li>
      <li>Attendance is marked only if present within the specified coordinates radius <code>(geofencing)</code>.</li>
    </ul>
  </li>

  <li><strong>Offline Attendance:</strong>
    <ul>
      <li>If internet connectivity is lost during attendance marking, data is saved in local storage.</li>
      <li>Attendance is synchronized with the server once internet connectivity is restored.</li>
    </ul>
  </li>

  <li><strong>Location Sharing:</strong>
    <ul>
      <li>Employees can send their coordinates to the admin for approval.</li>
      <li>Admin approves or disapproves based on the provided coordinates.</li>
    </ul>
  </li>

  <li><strong>Leave Application:</strong>
    <ul>
      <li>Dedicated section for leave applications.</li>
      <li>Employees submit leave requests through a form.</li>
    </ul>
  </li>

  <li><strong>Reports:</strong>
    <ul>
      <li>Reports are maintained for both leaves and attendance.</li>
      <li>Employees can view their historical attendance and leave records.</li>
    </ul>
  </li>

  <li><strong>Profile Editing:</strong>
    <ul>
      <li>Employees can change their name, app password, and profile picture in the profile editing section.</li>
    </ul>
  </li>
</ul>

# 🌟 CORE FEATURES

<ul>
  <li><strong>Flutter Framework:</strong>
    <ul>
      <li>Developed using the Flutter framework for a cross-platform and visually appealing user experience. 🌐</li>
    </ul>
  </li>

  <li><strong>MVC Architecture:</strong>
    <ul>
      <li>Implemented a well-organized MVC folder architecture for clear separation of concerns. 🏗️</li>
    </ul>
  </li>

  <li><strong>SQLite Local Storage:</strong>
    <ul>
      <li>Utilized SQLite for local storage, creating a robust CRUD (Create, Read, Update, Delete) application. 🗃️</li>
    </ul>
  </li>

  <li><strong>Fully Responsive Design:</strong>
    <ul>
      <li>Ensured a fully responsive user interface for seamless usage on various devices. 📱</li>
    </ul>
  </li>

  <li><strong>Mega Project:</strong>
    <ul>
      <li>Classified as a mega project, showcasing extensive features and capabilities. 🚀</li>
    </ul>
  </li>

  <li><strong>API Consumption:</strong>
    <ul>
      <li>Implemented API consumption for efficient data retrieval and posting. 🌐</li>
    </ul>
  </li>

  <li><strong>Live Location Tracking:</strong>
    <ul>
      <li>Integrated live location tracking to automate attendance marking. 🗺️</li>
    </ul>
  </li>

  <li><strong>Geofencing:</strong>
    <ul>
      <li>Implemented geofencing for precise location-based attendance and security. 📍</li>
    </ul>
  </li>

  <li><strong>Corporate Attendance Solution:</strong>
    <ul>
      <li>Ideal for companies to effortlessly manage employee attendance through the application. 🏢</li>
    </ul>
  </li>

  <li><strong>Bloc Pattern:</strong>
    <ul>
      <li>Implemented the Bloc pattern for effective state management and streamlined data flow. 🔄</li>
    </ul>
  </li>

  <li><strong>Optimized Performance:</strong>
    <ul>
      <li>Ensured a fast and lag-free app experience with optimized coding. ⚡</li>
    </ul>
  </li>

  <li><strong>Two Portals:</strong>
    <ul>
      <li>Incorporated two portals, admin, and employee, for distinct functionalities. 🚪</li>
    </ul>
  </li>

  <li><strong>Efficient Backend Handling:</strong>
    <ul>
      <li>Backend operations are efficiently managed for seamless app functionality. 🖥️</li>
    </ul>
  </li>

  <li><strong>Error Checks:</strong>
    <ul>
      <li>Implemented comprehensive error checks throughout the codebase to enhance reliability. 🚧</li>
    </ul>
  </li>
</ul>

![Static Badge](https://img.shields.io/badge/Flutter-blue?style=flat)
![Static Badge](https://img.shields.io/badge/Bloc-blue?style=flat&label=Flutter&labelColor=%23021691)
![SQLite Badge](https://img.shields.io/badge/Sqlite-white?style=flat)
![MVC Architecture Badge](https://img.shields.io/badge/MVC%20Architecture-white?style=flat)
![Responsive Design Badge](https://img.shields.io/badge/Responsive-Design-green?style=flat&labelColor=white)
![Geofencing Badge](https://img.shields.io/badge/Geofencing-orange?style=flat)
![REST API Integration Badge](https://img.shields.io/badge/REST%20API-darkblue?style=flat)
![CRUD Operations Badge](https://img.shields.io/badge/Operations-green?style=flat&label=CRUD&labelColor=white)




# 🤝 Explore and Collaborate:
<p>I've poured my heart, soul, and a touch of wizardry into this Flutter spectacle. Now it's yours to explore! 🚀✨ <br> If you share the passion for efficient coding or have collaboration ideas, my virtual door is always open. Let's craft some tech poetry together. 💻🔗</p>

# 🚩 Get Started:
<ol>
  <li>Clone the repository</li>
  <li>Run flutter pub get to install dependencies</li>
  <li>Dive into the magic! ✨</li>
</ol>
<p>Feel free to reach out for collaboration or to share your ideas. Let's make tech magic! 🚀✨</p>
