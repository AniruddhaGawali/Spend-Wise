import React from "react";
import { LogIn } from "@/app/components/LogIn/page";
import { Navbar } from "@/app/components/Navbar/page";

const logInPage = () => {
  return (
    <div>
      <Navbar />
      <LogIn />    
    </div>
  );
};

export default logInPage;
