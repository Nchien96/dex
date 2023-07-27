import { Routes, Route } from "react-router-dom";
import Header from "./components/Header";
import Swap from "./components/Swap/Swap";

function App() {
  return (
    <div className="h-screen gradient-bg-hero">
      <Header />
      <Routes>
        <Route path="/Faucet" element={<Swap />}></Route>
      </Routes>
    </div>
  );
}

export default App;
